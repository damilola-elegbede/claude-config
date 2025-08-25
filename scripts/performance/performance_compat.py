#!/usr/bin/env python3
"""
Performance Compatibility Layer
==============================

Provides performance optimizations using only standard library modules.
This ensures compatibility across all Python environments without external dependencies.

Implements:
- Async-style file operations using thread pools
- Memory monitoring using standard library
- Concurrent processing with ThreadPoolExecutor
- Intelligent caching with built-in data structures
"""

import asyncio
import concurrent.futures
import hashlib
import json
import os
import resource
import sys
import time
import threading
from pathlib import Path
from typing import Dict, List, Any, Optional, Union
import tracemalloc

class AsyncFileCompat:
    """Async file operations compatibility layer."""
    
    def __init__(self, file_path: Union[str, Path], mode: str = 'r', encoding: str = 'utf-8'):
        self.file_path = Path(file_path)
        self.mode = mode
        self.encoding = encoding
        self.executor = concurrent.futures.ThreadPoolExecutor(max_workers=4)
    
    async def __aenter__(self):
        return self
    
    async def __aexit__(self, exc_type, exc_val, exc_tb):
        self.executor.shutdown(wait=False)
    
    async def read(self) -> str:
        """Read file content asynchronously."""
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(self.executor, self._sync_read)
    
    async def write(self, content: str) -> None:
        """Write file content asynchronously."""
        loop = asyncio.get_event_loop()
        await loop.run_in_executor(self.executor, self._sync_write, content)
    
    def _sync_read(self) -> str:
        """Synchronous read operation."""
        with open(self.file_path, self.mode, encoding=self.encoding) as f:
            return f.read()
    
    def _sync_write(self, content: str) -> None:
        """Synchronous write operation."""
        with open(self.file_path, self.mode, encoding=self.encoding) as f:
            f.write(content)

def async_open(file_path: Union[str, Path], mode: str = 'r', encoding: str = 'utf-8'):
    """Compatibility function for aiofiles.open."""
    return AsyncFileCompat(file_path, mode, encoding)

class MemoryMonitor:
    """Memory monitoring using standard library."""
    
    @staticmethod
    def get_memory_usage() -> Dict[str, float]:
        """Get current memory usage in MB."""
        try:
            # Try to get memory info from resource module (Unix-like systems)
            usage = resource.getrusage(resource.RUSAGE_SELF)
            # maxrss is in KB on Linux, bytes on macOS
            if sys.platform == 'darwin':  # macOS
                memory_mb = usage.ru_maxrss / 1024 / 1024
            else:  # Linux and others
                memory_mb = usage.ru_maxrss / 1024
            
            return {
                'rss': memory_mb,
                'peak': memory_mb,
                'available': True
            }
        except (ImportError, AttributeError):
            # Fallback for systems where resource module is limited
            return {
                'rss': 0.0,
                'peak': 0.0,
                'available': False
            }
    
    @staticmethod
    def start_memory_tracing():
        """Start memory tracing using tracemalloc."""
        tracemalloc.start()
    
    @staticmethod
    def get_traced_memory() -> tuple:
        """Get traced memory usage."""
        try:
            return tracemalloc.get_traced_memory()
        except RuntimeError:
            # tracemalloc not started
            return (0, 0)
    
    @staticmethod
    def stop_memory_tracing():
        """Stop memory tracing."""
        try:
            tracemalloc.stop()
        except RuntimeError:
            # tracemalloc not running
            pass

class PerformanceCache:
    """High-performance caching using standard library."""
    
    def __init__(self, max_size: int = 1000):
        self.cache: Dict[str, Any] = {}
        self.access_times: Dict[str, float] = {}
        self.max_size = max_size
        self.lock = threading.RLock()
    
    def get(self, key: str) -> Optional[Any]:
        """Get item from cache."""
        with self.lock:
            if key in self.cache:
                self.access_times[key] = time.time()
                return self.cache[key]
            return None
    
    def put(self, key: str, value: Any) -> None:
        """Put item in cache with LRU eviction."""
        with self.lock:
            # Evict if cache is full
            if len(self.cache) >= self.max_size and key not in self.cache:
                self._evict_lru()
            
            self.cache[key] = value
            self.access_times[key] = time.time()
    
    def _evict_lru(self):
        """Evict least recently used item."""
        if not self.access_times:
            return
        
        lru_key = min(self.access_times.keys(), key=lambda k: self.access_times[k])
        del self.cache[lru_key]
        del self.access_times[lru_key]
    
    def clear(self):
        """Clear cache."""
        with self.lock:
            self.cache.clear()
            self.access_times.clear()
    
    def size(self) -> int:
        """Get cache size."""
        return len(self.cache)

class FileHashCache:
    """File hash caching for change detection."""
    
    def __init__(self, cache_file: Path):
        self.cache_file = cache_file
        self.cache: Dict[str, Dict[str, Any]] = {}
        self._load_cache()
    
    def _load_cache(self):
        """Load cache from disk."""
        if self.cache_file.exists():
            try:
                with open(self.cache_file, 'r') as f:
                    self.cache = json.load(f)
            except (json.JSONDecodeError, IOError):
                self.cache = {}
    
    def save_cache(self):
        """Save cache to disk."""
        try:
            self.cache_file.parent.mkdir(parents=True, exist_ok=True)
            with open(self.cache_file, 'w') as f:
                json.dump(self.cache, f, indent=2)
        except IOError:
            pass  # Fail silently
    
    def get_file_hash(self, file_path: Path) -> str:
        """Get file hash efficiently."""
        try:
            hasher = hashlib.md5()
            with open(file_path, 'rb') as f:
                for chunk in iter(lambda: f.read(8192), b""):
                    hasher.update(chunk)
            return hasher.hexdigest()
        except IOError:
            return ""
    
    def has_changed(self, file_path: Path) -> bool:
        """Check if file has changed."""
        if not file_path.exists():
            return False
        
        file_key = str(file_path)
        current_mtime = file_path.stat().st_mtime
        current_size = file_path.stat().st_size
        
        if file_key in self.cache:
            cached_info = self.cache[file_key]
            if (cached_info.get('mtime') == current_mtime and 
                cached_info.get('size') == current_size):
                return False
        
        # File changed or not in cache
        current_hash = self.get_file_hash(file_path)
        self.cache[file_key] = {
            'hash': current_hash,
            'mtime': current_mtime,
            'size': current_size,
            'last_check': time.time()
        }
        
        return True

class ConcurrentExecutor:
    """Concurrent execution using ThreadPoolExecutor."""
    
    def __init__(self, max_workers: int = None):
        # Default to min(32, (os.cpu_count() or 1) + 4) like ThreadPoolExecutor
        if max_workers is None:
            max_workers = min(32, (os.cpu_count() or 1) + 4)
        
        self.executor = concurrent.futures.ThreadPoolExecutor(max_workers=max_workers)
    
    async def run_concurrent(self, func, items: List[Any], *args, **kwargs) -> List[Any]:
        """Run function concurrently on list of items."""
        loop = asyncio.get_event_loop()
        
        # Create futures for all items
        futures = [
            loop.run_in_executor(self.executor, func, item, *args, **kwargs)
            for item in items
        ]
        
        # Wait for all to complete
        results = await asyncio.gather(*futures, return_exceptions=True)
        return results
    
    def shutdown(self):
        """Shutdown executor."""
        self.executor.shutdown(wait=False)

# Compatibility functions that match external library APIs
async def aiofiles_open(file_path: Union[str, Path], mode: str = 'r', encoding: str = 'utf-8'):
    """Compatibility function for aiofiles.open."""
    return async_open(file_path, mode, encoding)

def get_memory_info():
    """Compatibility function for psutil memory info."""
    return MemoryMonitor.get_memory_usage()

# Export compatibility layer
__all__ = [
    'AsyncFileCompat',
    'async_open', 
    'MemoryMonitor',
    'PerformanceCache',
    'FileHashCache',
    'ConcurrentExecutor',
    'aiofiles_open',
    'get_memory_info'
]