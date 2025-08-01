# /data Command

## Description
Quickly access expert data engineering through Claude orchestration for enterprise-scale data platforms and analytics infrastructure. Claude coordinates with the data-platform-engineer specialist who specializes in building data systems processing petabytes daily, implementing real-time analytics with <100ms query latency, and architecting data lakes serving 1000+ data scientists with 99.9% pipeline reliability.

## Behavior
This command coordinates with the data-platform-engineer specialist to architect and implement mission-critical data platforms including distributed data processing handling billions of records, real-time streaming architectures with exactly-once semantics, comprehensive data governance frameworks ensuring GDPR/CCPA compliance, and self-service analytics platforms enabling non-technical users.

## Usage
```
/data [specific data engineering requirement]
```

## Real-World Use Cases

### High-Performance Data Processing
- `/data build Spark pipeline processing 10TB+ daily with <4hr SLA and automatic recovery`
- `/data implement real-time analytics serving 100K+ queries/sec with ClickHouse clustering`
- `/data design CDC pipeline replicating 1B+ database changes with <5min latency`
- `/data optimize data warehouse reducing query time from hours to <30s using partitioning`

### Enterprise Data Architecture
- `/data create data mesh architecture with domain-owned data products and federated governance`
- `/data implement data lake with Delta Lake supporting ACID transactions on 100TB+ datasets`
- `/data build feature store serving ML models with <10ms lookup time and version management`
- `/data design multi-cloud data platform with disaster recovery and cost optimization`

### Streaming & Real-Time Systems
- `/data implement Kafka Connect pipeline with exactly-once semantics processing 1M+ events/sec`
- `/data build real-time recommendation engine using Flink with <100ms processing latency`
- `/data create event-driven data architecture with schema evolution and backward compatibility`
- `/data design IoT data pipeline handling 10M+ sensor readings/hour with anomaly detection`

## Expert Capabilities

### Big Data Processing Mastery
- **Apache Spark**: Catalyst optimizer, custom data sources, memory management, performance tuning
- **Distributed Computing**: Partitioning strategies, shuffle optimization, resource allocation
- **Data Formats**: Parquet, Delta Lake, Iceberg with schema evolution and time travel
- **Performance Optimization**: Query optimization reducing processing time by 90%+

### Real-Time Streaming Architecture
- **Apache Kafka**: Multi-region clusters, exactly-once semantics, schema registry, Connect framework
- **Stream Processing**: Apache Flink, Kafka Streams with windowing, joins, state management
- **Event-Driven Architecture**: Event sourcing, CQRS, saga patterns for data consistency
- **Low-Latency Processing**: Sub-100ms stream processing with back-pressure handling

### Data Warehouse & Analytics
- **Modern Data Stack**: Snowflake, BigQuery, Redshift with advanced optimization techniques
- **Dimensional Modeling**: Star schema, slowly changing dimensions, data vault methodology
- **Query Optimization**: Materialized views, partitioning, columnar storage optimization
- **Self-Service Analytics**: dbt modeling, Looker/Tableau integration, semantic layers

### Data Quality & Governance
- **Data Quality**: Great Expectations, custom validation rules, automated anomaly detection
- **Data Lineage**: Apache Atlas, DataHub with end-to-end tracking and impact analysis
- **Privacy Engineering**: GDPR compliance, data anonymization, privacy-preserving analytics
- **Data Catalog**: Metadata management, data discovery, automated documentation

## Performance Benchmarks
- **Processing Throughput**: 10TB+/hour with linear scaling and cost optimization
- **Query Performance**: p95 <10s for complex analytical queries on billion-row tables
- **Pipeline Reliability**: 99.9% uptime with automated error handling and recovery
- **Real-Time Latency**: <100ms end-to-end for critical streaming applications

## Technology Stack Expertise

### Data Processing Frameworks
- **Apache Spark**: PySpark, Scala, structured streaming, Delta Lake integration
- **Hadoop Ecosystem**: HDFS, YARN, Hive with Tez execution engine
- **Cloud Data Processing**: AWS EMR, GCP Dataproc, Azure HDInsight optimization
- **Serverless Processing**: AWS Glue, GCP Dataflow, Azure Data Factory automation

### Streaming & Messaging
- **Apache Kafka**: Confluent Platform, schema registry, ksqlDB, Kafka Connect
- **Stream Processing**: Apache Flink, Apache Storm, AWS Kinesis, Azure Stream Analytics
- **Message Queues**: Apache Pulsar, RabbitMQ for guaranteed delivery patterns
- **Event Streaming**: Schema evolution, event sourcing, distributed tracing

### Data Storage & Warehouses
- **Cloud Data Warehouses**: Snowflake, BigQuery, Redshift with advanced features
- **Data Lakes**: S3, ADLS, GCS with lifecycle management and cost optimization
- **NoSQL Databases**: Cassandra, MongoDB, DynamoDB for high-throughput workloads
- **Time-Series Databases**: InfluxDB, TimescaleDB, Prometheus for IoT and metrics

### Data Quality & Observability
- **Data Quality Tools**: Great Expectations, Deequ, custom validation frameworks
- **Monitoring**: Prometheus, Grafana, custom metrics for pipeline health
- **Data Lineage**: Apache Atlas, DataHub, custom tracking solutions
- **Cost Optimization**: Resource allocation, auto-scaling, spot instance usage

## Anti-Patterns Avoided
- **Data Swamps**: Comprehensive metadata management and data cataloging
- **Pipeline Monoliths**: Modular pipeline design with clear boundaries
- **Manual Operations**: Infrastructure as code, automated testing, CI/CD
- **Data Silos**: Cross-functional data sharing with governance frameworks
- **Performance Neglect**: Continuous monitoring and optimization strategies

## When to Engage

### Complexity Triggers
- Data processing exceeding 1TB/day requiring optimization strategies
- Real-time analytics with <100ms latency requirements at scale
- Multi-source data integration from >10 heterogeneous systems
- Regulatory compliance (GDPR, HIPAA) requiring comprehensive data governance
- ML/AI workloads requiring feature engineering at petabyte scale

### Scale Indicators
- Data lakes storing >100TB with complex query patterns
- Streaming systems processing >1M events/second with ordering guarantees
- Data warehouse supporting >1000 concurrent analytical users
- Cross-region data replication with consistency requirements
- Multi-tenant data platform with isolated compute and security

## Related Commands
- `/ml` - For ML infrastructure, feature stores, and model training pipelines
- `/backend` - For application data integration and API development
- `/architect` - For data architecture strategy and technology selection
- `/perf` - For advanced data processing optimization and cost reduction
