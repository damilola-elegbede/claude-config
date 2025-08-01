# /ml Command

## Description
Quickly access expert machine learning engineering through Claude orchestration for production-scale AI systems. Claude coordinates with the ml-engineer specialist who specializes in deploying ML models serving 1M+ predictions/day with <50ms inference latency, implementing MLOps pipelines handling petabyte-scale datasets, and building real-time recommendation systems achieving 95%+ accuracy.

## Behavior
This command coordinates with the ml-engineer specialist to architect and implement enterprise-grade ML systems including distributed training on multi-GPU clusters, real-time inference infrastructure with auto-scaling, advanced feature stores, and comprehensive model monitoring with drift detection and automated retraining pipelines.

## Usage
```
/ml [specific ML engineering requirement]
```

## Real-World Use Cases

### High-Performance Inference Systems
- `/ml optimize BERT model from 200ms to <50ms inference using ONNX and TensorRT`
- `/ml build real-time recommendation engine serving 100K RPS with Redis feature store`
- `/ml implement model serving with auto-scaling handling 10x traffic spikes`
- `/ml deploy computer vision pipeline processing 1M images/hour on GPU clusters`

### MLOps & Production Pipelines
- `/ml build automated retraining pipeline triggered by model drift detection (PSI >0.2)`
- `/ml implement A/B testing framework comparing 5 model variants with statistical significance`
- `/ml design feature store with <10ms feature serving and version management`
- `/ml create MLOps pipeline with automated testing, staging, and canary deployments`

### Advanced ML Architecture
- `/ml implement federated learning system across 1000+ edge devices with differential privacy`
- `/ml build multi-armed bandit system for dynamic pricing with Thompson sampling`
- `/ml design ensemble model combining XGBoost, neural networks, and transformers`
- `/ml create real-time fraud detection system with <100ms decision latency`

## Expert Capabilities

### Model Development & Optimization
- **Deep Learning**: Transformer architectures, attention mechanisms, advanced regularization
- **Traditional ML**: Gradient boosting (XGBoost, LightGBM), ensemble methods, hyperparameter optimization
- **Model Compression**: Quantization, pruning, distillation reducing model size by 90%+
- **Transfer Learning**: Fine-tuning pre-trained models with domain adaptation techniques

### Production Inference Infrastructure
- **Model Serving**: TensorFlow Serving, TorchServe, Triton with batching and caching
- **Hardware Optimization**: GPU utilization >85%, mixed precision, custom CUDA kernels
- **Auto-Scaling**: Kubernetes HPA based on queue depth and inference latency
- **Edge Deployment**: TensorFlow Lite, ONNX Runtime for mobile and IoT devices

### Feature Engineering & Data Pipeline
- **Feature Stores**: Real-time and batch features with point-in-time correctness
- **Data Versioning**: DVC, MLflow tracking for reproducible experiments
- **Stream Processing**: Apache Kafka, Apache Flink for real-time feature computation
- **Data Quality**: Great Expectations for automated data validation and monitoring

### MLOps & Model Lifecycle Management
- **Continuous Training**: Automated pipelines with Kubeflow, MLflow, or Vertex AI
- **Model Monitoring**: Drift detection using statistical tests and distribution comparison
- **Experiment Tracking**: MLflow, Weights & Biases for model versioning and comparison  
- **Model Registry**: Centralized model management with staging and production promotion

## Performance Benchmarks
- **Inference Latency**: p95 <100ms for complex models, <10ms for lightweight models
- **Throughput**: 10K+ predictions/second per GPU with optimal batching
- **Model Accuracy**: >95% for classification tasks, <5% MAPE for regression
- **Training Efficiency**: Multi-GPU scaling achieving >80% efficiency on distributed training

## Technology Stack Expertise

### ML Frameworks & Libraries
- **PyTorch**: Advanced training loops, mixed precision, distributed training (DDP, FSDP)  
- **TensorFlow**: Custom layers, tf.data optimization, SavedModel format, TF-TRT
- **Scikit-learn**: Pipeline optimization, custom transformers, model selection
- **XGBoost/LightGBM**: Hyperparameter tuning, early stopping, feature importance

### Deployment & Serving
- **Docker**: Multi-stage builds for ML models, GPU runtime configuration
- **Kubernetes**: ML workload orchestration, resource allocation, job scheduling
- **Cloud Platforms**: AWS SageMaker, GCP Vertex AI, Azure ML for managed training/serving
- **Edge Computing**: TensorFlow Lite, ONNX Runtime, OpenVINO for device deployment

### Data Engineering Integration
- **Apache Spark**: Distributed feature engineering, model training on large datasets
- **Apache Airflow**: ML pipeline orchestration with dependency management
- **Delta Lake**: Data versioning and time travel for reproducible ML experiments
- **Apache Kafka**: Real-time data streaming for online learning and inference

### Monitoring & Observability
- **Model Monitoring**: Evidently AI, WhyLabs for drift detection and model performance
- **Metrics Collection**: Prometheus for model serving metrics, custom SLI/SLO definitions
- **Distributed Tracing**: Jaeger for request tracing through ML inference pipelines
- **Logging**: Structured logging for model predictions, feature values, and errors

## Anti-Patterns Avoided
- **Data Leakage**: Strict temporal splits, proper cross-validation strategies
- **Model Overfitting**: Early stopping, regularization, proper validation techniques
- **Training/Serving Skew**: Feature store consistency, containerized environments
- **Manual Deployment**: Automated CI/CD pipelines with model testing and validation
- **Monitoring Blindness**: Comprehensive drift detection and performance tracking

## When to Engage

### Complexity Triggers  
- Models requiring >1M predictions/day with strict latency requirements
- Training datasets >100GB requiring distributed computing strategies
- Real-time inference with <100ms latency and high availability requirements
- Multi-model systems requiring ensemble techniques and model orchestration
- Regulatory compliance requiring model explainability and audit trails

### Scale Indicators
- Feature engineering on >1TB datasets requiring distributed processing
- Model serving requiring auto-scaling across multiple regions
- A/B testing with statistical significance across >100K users
- Real-time ML systems processing >10K events/second
- Multi-stakeholder ML projects requiring model governance and collaboration

## Related Commands
- `/data` - For ETL pipelines and feature engineering at scale
- `/backend` - For ML API development and model serving infrastructure  
- `/perf` - For model inference optimization and hardware acceleration
- `/architect` - For ML system architecture and technology selection
