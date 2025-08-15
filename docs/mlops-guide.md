# ML Operations Guide - Phase 3 Intelligence Layer

<metadata>
  <guide-type>operations</guide-type>
  <complexity>enterprise</complexity>
  <target-audience>mlops-engineers, devops-teams, platform-engineers</target-audience>
  <version>1.0</version>
</metadata>

## Executive Summary

This comprehensive MLOps guide covers the complete machine learning operations pipeline
for the Phase 3 Intelligence Layer, including model training workflows, automated
deployment, monitoring systems, and performance optimization techniques. Designed for
enterprise-scale deployments with 99.9% uptime requirements.

## MLOps Architecture Overview

<mlops-architecture>
  <pipeline-stages>
    <stage name="data-ingestion" sla="real-time">

```text
- Metrics collection from distributed systems
- Feature engineering and validation
- Data quality monitoring and alerts
- Historical data management and retention
```

    </stage>

    <stage name="model-development" sla="continuous">

```text
- Experiment tracking and versioning
- Automated hyperparameter optimization
- Cross-validation with temporal splits
- Model comparison and selection
```

    </stage>

    <stage name="model-deployment" sla="zero-downtime">

```text
- Automated model packaging and testing
- Blue-green deployment with gradual rollout
- A/B testing framework for model comparison
- Rollback mechanisms and canary releases
```

    </stage>

    <stage name="model-monitoring" sla="continuous">

```text
- Real-time performance tracking
- Model drift detection and alerting
- Data quality monitoring
- Business impact measurement
```

    </stage>
  </pipeline-stages>
</mlops-architecture>

### Infrastructure Components

<infrastructure-stack>
  <component name="training-infrastructure" tier="compute">
    <specifications>

```text
- Kubernetes cluster with GPU nodes for training
- Distributed training support (Horovod, Ray)
- Auto-scaling based on training queue depth
- Spot instance integration for cost optimization
```

    </specifications>

    <resource-requirements>

```text
- CPU: 64+ cores for distributed training
- Memory: 256GB+ RAM for large dataset processing
- GPU: NVIDIA V100/A100 for deep learning models
- Storage: 1TB+ NVMe for fast data access
```

    </resource-requirements>
  </component>

  <component name="serving-infrastructure" tier="inference">
    <specifications>

```text
- High-availability model serving with load balancing
- Auto-scaling based on request volume and latency
- Multi-region deployment for disaster recovery
- Edge caching for frequently requested predictions
```

    </specifications>

    <performance-targets>

```text
- Latency: p99 < 100ms for real-time predictions
- Throughput: 10K+ requests per second per service
- Availability: 99.9% uptime with 4-9s SLA
- Scalability: 10x traffic spike handling
```

    </performance-targets>
  </component>

  <component name="data-infrastructure" tier="storage">
    <specifications>

```text
- Time-series database for metrics storage (InfluxDB)
- Feature store with real-time serving (Redis/Feast)
- Model registry for versioning (MLflow/DVC)
- Data lake for historical analysis (S3/GCS)
```

    </specifications>

    <data-management>

```text
- Data retention: 2 years for training data, 6 months for predictions
- Backup strategy: Daily incremental, weekly full backups
- Data lifecycle: Automated archival and deletion policies
- GDPR compliance: Data anonymization and deletion capabilities
```

    </data-management>
  </component>
</infrastructure-stack>

## Model Training Pipeline

### Data Pipeline Setup

<data-pipeline>
  <ingestion-workflow>
```yaml
# Airflow DAG for data ingestion
data_ingestion_dag:
  schedule_interval: "*/5 * * * *"  # Every 5 minutes

  tasks:
    extract_metrics:
      operator: PythonOperator
      function: extract_system_metrics
      timeout: 300
      retries: 3

    validate_data:
      operator: GreatExpectationsOperator
      expectation_suite: system_metrics_suite
      data_context: /opt/airflow/great_expectations

    transform_features:
      operator: SparkOperator
      application: /opt/spark/jobs/feature_engineering.py
      conf:
        spark.executor.instances: 4
        spark.executor.memory: 8g

    load_feature_store:
      operator: PythonOperator
      function: load_to_feature_store
      pool: feature_store_pool
```
  </ingestion-workflow>

  <feature-engineering>
```python
# Feature engineering pipeline
from feast import FeatureStore
from great_expectations.core import ExpectationSuite

class FeatureEngineeringPipeline:
    def __init__(self):
        self.feature_store = FeatureStore("feature_store.yaml")
        self.data_validator = DataValidator()

    def engineer_features(self, raw_metrics: pd.DataFrame) -> pd.DataFrame:
        """Engineer features for ML models"""

        # Time-based features
        features = self.create_time_features(raw_metrics)

        # Statistical aggregations
        features = self.add_rolling_statistics(features, windows=[5, 15, 60])

        # Derived features
        features = self.add_derived_features(features)

        # Validate feature quality
        validation_result = self.data_validator.validate(features)
        if not validation_result.success:
            raise FeatureValidationError(validation_result.errors)

        return features

    def create_time_features(self, df: pd.DataFrame) -> pd.DataFrame:
        """Create time-based features"""
        df['hour'] = df.timestamp.dt.hour
        df['day_of_week'] = df.timestamp.dt.dayofweek
        df['is_weekend'] = df.day_of_week.isin([5, 6])
        df['is_business_hours'] = df.hour.between(9, 17)
        return df

    def add_rolling_statistics(self, df: pd.DataFrame,
                               windows: List[int]) -> pd.DataFrame:
        """Add rolling window statistics"""
        for window in windows:
            for col in ['cpu_usage', 'memory_usage', 'disk_io']:
                df[f'{col}_mean_{window}m'] = (
                    df[col].rolling(f'{window}T').mean()
                )
                df[f'{col}_std_{window}m'] = (
                    df[col].rolling(f'{window}T').std()
                )
                df[f'{col}_max_{window}m'] = (
                    df[col].rolling(f'{window}T').max()
                )
        return df
```
  </feature-engineering>

  <data-validation>
```yaml
# Great Expectations suite for data quality
expectation_suite_name: system_metrics_suite

expectations:
  - expectation_type: expect_table_row_count_to_be_between
    kwargs:
      min_value: 100
      max_value: 10000

  - expectation_type: expect_column_values_to_not_be_null
    kwargs:
      column: timestamp

  - expectation_type: expect_column_values_to_be_between
    kwargs:
      column: cpu_usage
      min_value: 0
      max_value: 100

  - expectation_type: expect_column_values_to_be_between
    kwargs:
      column: memory_usage
      min_value: 0
      max_value: 100

  - expectation_type: expect_column_values_to_not_be_null
    kwargs:
      column: system_id
```
  </data-validation>
</data-pipeline>

### Training Workflow

<training-pipeline>
  <experiment-setup>
```python
# MLflow experiment tracking setup
import mlflow
import mlflow.xgboost
import mlflow.sklearn
from mlflow.tracking import MlflowClient

class ModelTrainingPipeline:
    def __init__(self, experiment_name: str):
        self.client = MlflowClient()
        self.experiment_name = experiment_name
        self.experiment_id = self._get_or_create_experiment()

    def train_performance_predictor(self, training_data: pd.DataFrame):
        """Train performance prediction models with experiment tracking"""

        with mlflow.start_run(experiment_id=self.experiment_id):
            # Log training parameters
            mlflow.log_params({
                'model_type': 'xgboost_ensemble',
                'training_samples': len(training_data),
                'feature_count': training_data.shape[1] - 1,
                'cross_validation_folds': 5
            })

            # Split data with temporal awareness
            X_train, X_val, y_train, y_val = self.temporal_split(
                training_data
            )

            # Train primary model (XGBoost)
            xgb_model = self.train_xgboost_model(X_train, y_train)

            # Train secondary model (LSTM)
            lstm_model = self.train_lstm_model(X_train, y_train)

            # Create ensemble model
            ensemble_model = self.create_ensemble([xgb_model, lstm_model])

            # Validate on test set
            validation_metrics = self.validate_model(
                ensemble_model, X_val, y_val
            )

            # Log metrics
            mlflow.log_metrics(validation_metrics)

            # Log model artifacts
            mlflow.sklearn.log_model(
                ensemble_model,
                "performance_predictor",
                signature=self.get_model_signature(X_train, y_train)
            )

            return ensemble_model, validation_metrics
```
  </experiment-setup>

  <hyperparameter-optimization>
```python
# Automated hyperparameter tuning with Optuna
import optuna
from optuna.integration.mlflow import MLflowCallback

class HyperparameterOptimizer:
    def __init__(self, n_trials: int = 100):
        self.n_trials = n_trials
        self.study = None

    def optimize_xgboost(self, X_train, y_train, X_val, y_val):
        """Optimize XGBoost hyperparameters"""

        def objective(trial):
            params = {
                'n_estimators': trial.suggest_int('n_estimators', 100, 1000),
                'max_depth': trial.suggest_int('max_depth', 3, 10),
                'learning_rate': trial.suggest_float(
                    'learning_rate', 0.01, 0.3
                ),
                'subsample': trial.suggest_float('subsample', 0.6, 1.0),
                'colsample_bytree': trial.suggest_float(
                    'colsample_bytree', 0.6, 1.0
                ),
                'reg_alpha': trial.suggest_float('reg_alpha', 0, 10),
                'reg_lambda': trial.suggest_float('reg_lambda', 0, 10)
            }

            model = xgb.XGBRegressor(**params, random_state=42)
            model.fit(X_train, y_train)

            y_pred = model.predict(X_val)
            mse = mean_squared_error(y_val, y_pred)

            return mse

        # Create study with MLflow integration
        mlflow_callback = MLflowCallback(
            tracking_uri=mlflow.get_tracking_uri(),
            metric_name="validation_mse"
        )

        self.study = optuna.create_study(
            direction='minimize',
            sampler=optuna.samplers.TPESampler(seed=42)
        )

        self.study.optimize(
            objective,
            n_trials=self.n_trials,
            callbacks=[mlflow_callback]
        )

        return self.study.best_params
```
  </hyperparameter-optimization>

  <model-validation>
```python
# Comprehensive model validation
class ModelValidator:
    def __init__(self):
        self.validation_metrics = {}

    def validate_performance_predictor(self, model, X_test, y_test):
        """Validate performance prediction model"""

        # Generate predictions
        y_pred = model.predict(X_test)
        y_pred_proba = (
            model.predict_proba(X_test)[:, 1]
            if hasattr(model, 'predict_proba') else None
        )

        # Classification metrics
        metrics = {
            'accuracy': accuracy_score(y_test, y_pred > 0.5),
            'precision': precision_score(y_test, y_pred > 0.5),
            'recall': recall_score(y_test, y_pred > 0.5),
            'f1_score': f1_score(y_test, y_pred > 0.5),
            'auc_roc': (
                roc_auc_score(y_test, y_pred_proba)
                if y_pred_proba is not None else None
            )
        }

        # Regression metrics for continuous predictions
        metrics.update({
            'mse': mean_squared_error(y_test, y_pred),
            'mae': mean_absolute_error(y_test, y_pred),
            'r2_score': r2_score(y_test, y_pred)
        })

        # Time-series specific metrics
        metrics.update(self.calculate_temporal_metrics(y_test, y_pred))

        # Business-specific metrics
        metrics.update(self.calculate_business_metrics(y_test, y_pred))

        return metrics

    def calculate_temporal_metrics(self, y_true, y_pred):
        """Calculate time-series specific validation metrics"""
        return {
            'temporal_consistency': self.calculate_temporal_consistency(
                y_true, y_pred
            ),
            'forecast_bias': np.mean(y_pred - y_true),
            'directional_accuracy': self.calculate_directional_accuracy(
                y_true, y_pred
            )
        }

    def calculate_business_metrics(self, y_true, y_pred):
        """Calculate business-impact metrics"""
        # Cost of false positives vs false negatives
        false_positive_cost = 10  # Cost of unnecessary alerts
        false_negative_cost = 100  # Cost of missed incidents

        tp = np.sum((y_true == 1) & (y_pred > 0.5))
        fp = np.sum((y_true == 0) & (y_pred > 0.5))
        fn = np.sum((y_true == 1) & (y_pred <= 0.5))
        tn = np.sum((y_true == 0) & (y_pred <= 0.5))

        total_cost = fp * false_positive_cost + fn * false_negative_cost

        return {
            'business_cost': total_cost,
            'cost_per_prediction': total_cost / len(y_true),
            'alert_precision': (
                tp / (tp + fp) if (tp + fp) > 0 else 0
            )
        }
```
  </model-validation>
</training-pipeline>

## Model Deployment Pipeline

### Automated Deployment Workflow

<deployment-pipeline>
  <ci-cd-setup>
```yaml
# GitHub Actions workflow for model deployment
name: ML Model Deployment

on:
  push:
    branches: [main]
    paths: ['models/**', 'ml-pipeline/**']
  pull_request:
    branches: [main]

jobs:
  test-models:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v3
        with:
          python-version: '3.9'

      - name: Install dependencies
        run: |
          pip install -r requirements.txt
          pip install -r requirements-test.txt

      - name: Run model tests
        run: |
          pytest tests/models/ -v --cov=ml_pipeline

      - name: Validate model performance
        run: |
          python scripts/validate-model-performance.py --threshold=0.95

  build-and-push:
    needs: test-models
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v3

      - name: Build Docker image
        run: |
          docker build -t claude-ml:${{ github.sha }} \
            -f docker/Dockerfile.ml-service .

      - name: Push to registry
        run: |
          docker tag claude-ml:${{ github.sha }} \
            ${{ secrets.REGISTRY }}/claude-ml:${{ github.sha }}
          docker push ${{ secrets.REGISTRY }}/claude-ml:${{ github.sha }}

  deploy-staging:
    needs: build-and-push
    runs-on: ubuntu-latest
    environment: staging
    steps:
      - name: Deploy to staging
        run: |
          kubectl set image deployment/ml-service \
            ml-service=${{ secrets.REGISTRY }}/claude-ml:${{ github.sha }}
          kubectl rollout status deployment/ml-service -n staging

      - name: Run integration tests
        run: |
          python tests/integration/test_ml_api.py --environment=staging

  deploy-production:
    needs: deploy-staging
    runs-on: ubuntu-latest
    environment: production
    if: github.ref == 'refs/heads/main'
    steps:
      - name: Deploy to production (blue-green)
        run: |
          # Deploy to green environment
          kubectl apply -f k8s/production/ml-service-green.yaml

          # Wait for green deployment to be ready
          kubectl rollout status deployment/ml-service-green \
            -n production

          # Run smoke tests on green deployment
          python scripts/smoke-tests.py --target=green

          # Switch traffic to green (gradual rollout)
          python scripts/traffic-split.py --green-percentage=10
          sleep 300  # Wait 5 minutes

          python scripts/traffic-split.py --green-percentage=50
          sleep 300

          python scripts/traffic-split.py --green-percentage=100

          # Cleanup old blue deployment
          kubectl delete deployment/ml-service-blue -n production
```
  </ci-cd-setup>

  <canary-deployment>
```python
# Canary deployment controller
class CanaryDeploymentController:
    def __init__(self, k8s_client, monitoring_client):
        self.k8s = k8s_client
        self.monitoring = monitoring_client
        self.canary_config = self.load_canary_config()

    def deploy_canary(self, new_model_version: str):
        """Deploy new model version using canary strategy"""

        # Deploy canary version
        canary_deployment = self.create_canary_deployment(new_model_version)
        self.k8s.create_deployment(canary_deployment)

        # Gradual traffic shift
        traffic_percentages = [5, 10, 25, 50, 100]

        for percentage in traffic_percentages:
            # Update traffic split
            self.update_traffic_split(canary_percentage=percentage)

            # Monitor metrics for anomalies
            monitoring_period = 300  # 5 minutes
            if not self.monitor_canary_health(monitoring_period):
                self.rollback_deployment()
                raise CanaryDeploymentError("Health check failed, rolling back")

            # Gradual increase
            time.sleep(monitoring_period)

        # Promote canary to stable
        self.promote_canary_to_stable()

    def monitor_canary_health(self, monitoring_period: int) -> bool:
        """Monitor canary deployment health"""

        # Define success criteria
        criteria = {
            'error_rate': 0.01,  # < 1% error rate
            'latency_p99': 100,  # < 100ms p99 latency
            'prediction_accuracy': 0.95,  # > 95% accuracy
            'throughput_degradation': 0.1  # < 10% throughput degradation
        }

        # Collect metrics
        end_time = time.time()
        start_time = end_time - monitoring_period

        metrics = self.monitoring.get_metrics(
            start_time=start_time,
            end_time=end_time,
            labels={'deployment': 'canary'}
        )

        # Check each criterion
        for criterion, threshold in criteria.items():
            if metrics[criterion] > threshold:
                logger.error(
                    f"Canary health check failed: {criterion} = "
                    f"{metrics[criterion]} > {threshold}"
                )
                return False

        return True
```
  </canary-deployment>

  <rollback-mechanism>
```python
# Automated rollback system
class RollbackManager:
    def __init__(self):
        self.model_registry = ModelRegistry()
        self.deployment_manager = DeploymentManager()

    def execute_rollback(self, trigger_reason: str):
        """Execute automated rollback to previous stable version"""

        logger.warning(f"Initiating rollback due to: {trigger_reason}")

        # Get previous stable version
        current_version = self.model_registry.get_current_version()
        previous_version = (
            self.model_registry.get_previous_stable_version()
        )

        if not previous_version:
            raise RollbackError("No previous stable version available")

        # Create rollback deployment
        rollback_deployment = self.create_rollback_deployment(
            previous_version
        )

        # Execute rapid rollback (immediate traffic switch)
        self.deployment_manager.rapid_deploy(rollback_deployment)

        # Verify rollback success
        if self.verify_rollback_success():
            logger.info(
                f"Successfully rolled back from {current_version} "
                f"to {previous_version}"
            )

            # Mark current version as unstable
            self.model_registry.mark_version_unstable(
                current_version, trigger_reason
            )

            # Send notifications
            self.send_rollback_notifications(
                current_version, previous_version, trigger_reason
            )
        else:
            raise RollbackError("Rollback verification failed")

    def verify_rollback_success(self) -> bool:
        """Verify that rollback was successful"""

        # Wait for deployment to stabilize
        time.sleep(60)

        # Check key metrics
        metrics = self.monitoring.get_current_metrics()

        success_criteria = {
            'deployment_ready': True,
            'error_rate': lambda x: x < 0.005,
            'response_time': lambda x: x < 50,
            'prediction_throughput': lambda x: x > 1000
        }

        for criterion, check in success_criteria.items():
            value = metrics.get(criterion)
            if callable(check):
                if not check(value):
                    return False
            elif value != check:
                return False

        return True
```
  </rollback-mechanism>
</deployment-pipeline>

## Model Monitoring and Observability

### Performance Monitoring

<monitoring-setup>
  <metrics-collection>
```python
# Comprehensive metrics collection for ML models
from prometheus_client import Counter, Histogram, Gauge, start_http_server

class MLMetricsCollector:
    def __init__(self):
        # Prediction metrics
        self.prediction_counter = Counter(
            'ml_predictions_total',
            'Total number of predictions made',
            ['model_name', 'model_version', 'prediction_type']
        )

        self.prediction_latency = Histogram(
            'ml_prediction_duration_seconds',
            'Time spent on predictions',
            ['model_name', 'model_version'],
            buckets=(0.001, 0.01, 0.05, 0.1, 0.5, 1.0, 2.0, 5.0)
        )

        # Model performance metrics
        self.model_accuracy = Gauge(
            'ml_model_accuracy',
            'Current model accuracy',
            ['model_name', 'model_version', 'metric_type']
        )

        self.model_drift = Gauge(
            'ml_model_drift_score',
            'Model drift detection score',
            ['model_name', 'feature_name', 'drift_type']
        )

        # Business metrics
        self.false_positive_rate = Gauge(
            'ml_false_positive_rate',
            'False positive rate for predictions',
            ['model_name', 'prediction_threshold']
        )

        self.business_impact = Counter(
            'ml_business_impact_total',
            'Business impact of predictions',
            ['model_name', 'impact_type', 'severity']
        )

    @contextmanager
    def track_prediction(self, model_name: str, model_version: str,
                       prediction_type: str):
        """Context manager to track prediction metrics"""
        start_time = time.time()
        try:
            yield
            self.prediction_counter.labels(
                model_name=model_name,
                model_version=model_version,
                prediction_type=prediction_type
            ).inc()
        finally:
            duration = time.time() - start_time
            self.prediction_latency.labels(
                model_name=model_name,
                model_version=model_version
            ).observe(duration)
```
  </metrics-collection>

  <drift-detection>
```python
# Model drift detection system
import scipy.stats as stats
from evidently.metric_preset import DataDriftPreset
from evidently.report import Report

class DriftDetector:
    def __init__(self, reference_data: pd.DataFrame):
        self.reference_data = reference_data
        self.drift_thresholds = {
            'kolmogorov_smirnov': 0.05,
            'population_stability_index': 0.1,
            'jensen_shannon_distance': 0.1
        }

    def detect_feature_drift(self,
                              current_data: pd.DataFrame) -> Dict[str, float]:
        """Detect drift in individual features"""

        drift_scores = {}

        for column in self.reference_data.columns:
            if column in current_data.columns:
                # KS test for numerical features
                if pd.api.types.is_numeric_dtype(
                    self.reference_data[column]
                ):
                    ks_statistic, p_value = stats.ks_2samp(
                        self.reference_data[column].dropna(),
                        current_data[column].dropna()
                    )
                    drift_scores[f'{column}_ks_test'] = ks_statistic

                # PSI for categorical features
                else:
                    psi_score = self.calculate_psi(
                        self.reference_data[column],
                        current_data[column]
                    )
                    drift_scores[f'{column}_psi'] = psi_score

        return drift_scores

    def detect_prediction_drift(self,
                                 reference_predictions: np.ndarray,
                                 current_predictions: np.ndarray) -> float:
        """Detect drift in model predictions"""

        # Jensen-Shannon divergence for prediction distributions
        js_distance = self.jensen_shannon_distance(
            reference_predictions, current_predictions
        )

        return js_distance

    def generate_drift_report(self, current_data: pd.DataFrame) -> Report:
        """Generate comprehensive drift detection report"""

        data_drift_report = Report(metrics=[DataDriftPreset()])
        data_drift_report.run(
            reference_data=self.reference_data,
            current_data=current_data
        )

        return data_drift_report

    def calculate_psi(self, reference: pd.Series, current: pd.Series,
                      bins: int = 10) -> float:
        """Calculate Population Stability Index"""

        # Create bins based on reference data
        _, bin_edges = np.histogram(reference.dropna(), bins=bins)

        # Calculate distributions
        ref_counts, _ = np.histogram(reference.dropna(), bins=bin_edges)
        cur_counts, _ = np.histogram(current.dropna(), bins=bin_edges)

        # Convert to proportions
        ref_props = ref_counts / len(reference.dropna())
        cur_props = cur_counts / len(current.dropna())

        # Add small constant to avoid division by zero
        ref_props = np.where(ref_props == 0, 0.0001, ref_props)
        cur_props = np.where(cur_props == 0, 0.0001, cur_props)

        # Calculate PSI
        psi = np.sum(
            (cur_props - ref_props) * np.log(cur_props / ref_props)
        )

        return psi
```
  </drift-detection>

  <alerting-system>
```python
# Intelligent alerting system for ML models
class MLAlertManager:
    def __init__(self):
        self.alert_channels = self.setup_alert_channels()
        self.alert_rules = self.load_alert_rules()
        self.alert_history = AlertHistory()

    def setup_alert_channels(self) -> Dict[str, AlertChannel]:
        """Setup various alert channels"""
        return {
            'slack': SlackChannel(
                webhook_url=os.getenv('SLACK_WEBHOOK_URL')
            ),
            'email': EmailChannel(
                smtp_server=os.getenv('SMTP_SERVER')
            ),
            'pagerduty': PagerDutyChannel(
                integration_key=os.getenv('PAGERDUTY_KEY')
            ),
            'dashboard': DashboardChannel()
        }

    def evaluate_alerts(self, metrics: Dict[str, float]):
        """Evaluate current metrics against alert rules"""

        triggered_alerts = []

        for rule_name, rule in self.alert_rules.items():
            if self.evaluate_rule(rule, metrics):
                alert = self.create_alert(rule_name, rule, metrics)

                # Check if this alert should be suppressed
                if not self.should_suppress_alert(alert):
                    triggered_alerts.append(alert)
                    self.send_alert(alert)
                    self.alert_history.record(alert)

        return triggered_alerts

    def create_alert(self, rule_name: str, rule: Dict,
                     metrics: Dict) -> Alert:
        """Create alert object with context and recommendations"""

        return Alert(
            name=rule_name,
            severity=rule['severity'],
            message=rule['message_template'].format(**metrics),
            metrics=metrics,
            timestamp=datetime.utcnow(),
            recommendations=self.generate_recommendations(
                rule_name, metrics
            ),
            runbook_url=rule.get('runbook_url'),
            auto_resolve=rule.get('auto_resolve', False)
        )

    def generate_recommendations(self, rule_name: str,
                                 metrics: Dict) -> List[str]:
        """Generate contextual recommendations for alerts"""

        recommendations = []

        if rule_name == 'high_prediction_latency':
            recommendations.extend([
                "Check model serving resource utilization",
                "Consider enabling prediction caching",
                "Review feature computation complexity",
                "Scale up inference service replicas"
            ])

        elif rule_name == 'model_accuracy_degradation':
            recommendations.extend([
                "Investigate recent data changes",
                "Check for model drift",
                "Consider model retraining",
                "Review feature pipeline integrity"
            ])

        elif rule_name == 'high_false_positive_rate':
            recommendations.extend([
                "Adjust prediction thresholds",
                "Review recent model changes",
                "Analyze false positive patterns",
                "Consider additional feature engineering"
            ])

        return recommendations
```
  </alerting-system>
</monitoring-setup>

### Dashboards and Visualization

<dashboard-setup>
  <grafana-dashboard>
    ```json
    {
      "dashboard": {
        "title": "ML Operations Dashboard - Phase 3 Intelligence Layer",
        "panels": [
          {
            "title": "Prediction Volume and Latency",
            "type": "graph",
            "targets": [
              {
                "expr": "rate(ml_predictions_total[5m])",
                "legendFormat": "Predictions/sec - {{model_name}}"
              },
              {
                "expr": "histogram_quantile(0.99, rate(ml_prediction_duration_seconds_bucket[5m]))",
                "legendFormat": "P99 Latency - {{model_name}}"
              }
            ]
          },
          {
            "title": "Model Accuracy Trends",
            "type": "graph",
            "targets": [
              {
                "expr": "ml_model_accuracy",
                "legendFormat": "{{metric_type}} - {{model_name}}"
              }
            ],
            "yAxes": [
              {
                "min": 0.8,
                "max": 1.0,
                "unit": "percentunit"
              }
            ]
          },
          {
            "title": "Feature Drift Scores",
            "type": "heatmap",
            "targets": [
              {
                "expr": "ml_model_drift_score",
                "legendFormat": "{{feature_name}}"
              }
            ]
          },
          {
            "title": "Business Impact Metrics",
            "type": "stat",
            "targets": [
              {
                "expr": "rate(ml_business_impact_total{impact_type='cost_savings'}[1h])",
                "legendFormat": "Cost Savings/hour"
              },
              {
                "expr": "rate(ml_business_impact_total{impact_type='incidents_prevented'}[1h])",
                "legendFormat": "Incidents Prevented/hour"
              }
            ]
          },
          {
            "title": "Model Health Status",
            "type": "table",
            "targets": [
              {
                "expr": "ml_model_accuracy{metric_type='overall'}",
                "format": "table"
              }
            ],
            "transformations": [
              {
                "id": "organize",
                "options": {
                  "includeByName": {
                    "model_name": true,
                    "model_version": true,
                    "Value": true
                  },
                  "renameByName": {
                    "Value": "Accuracy"
                  }
                }
              }
            ]
          }
        ]
      }
    }
    ```
  </grafana-dashboard>

  <custom-dashboard>
    ```python
    # Custom ML operations dashboard
    import streamlit as st
    import plotly.graph_objects as go
    import plotly.express as px

    class MLOpsDashboard:
        def __init__(self):
            self.metrics_client = PrometheusClient()
            self.model_registry = ModelRegistry()

        def render_dashboard(self):
            """Render comprehensive ML operations dashboard"""

            st.title("ML Operations Dashboard - Phase 3 Intelligence Layer")

            # Sidebar for model selection
            models = self.model_registry.list_active_models()
            selected_model = st.sidebar.selectbox("Select Model", models)

            # Main dashboard sections
            col1, col2, col3 = st.columns(3)

            with col1:
                self.render_performance_metrics(selected_model)

            with col2:
                self.render_drift_analysis(selected_model)

            with col3:
                self.render_business_metrics(selected_model)

            # Full-width sections
            self.render_prediction_timeline(selected_model)
            self.render_alert_summary()
            self.render_model_comparison()

        def render_performance_metrics(self, model_name: str):
            """Render real-time performance metrics"""

            st.subheader("Performance Metrics")

            # Get current metrics
            metrics = self.metrics_client.get_current_metrics(model_name)

            # Display key metrics
            col1, col2 = st.columns(2)
            with col1:
                st.metric(
                    "Accuracy",
                    f"{metrics['accuracy']:.3f}",
                    delta=f"{metrics['accuracy_change']:+.3f}"
                )
                st.metric(
                    "Predictions/min",
                    f"{metrics['prediction_rate']:.0f}",
                    delta=f"{metrics['rate_change']:+.0f}"
                )

            with col2:
                st.metric(
                    "P99 Latency",
                    f"{metrics['p99_latency']:.0f}ms",
                    delta=f"{metrics['latency_change']:+.0f}ms"
                )
                st.metric(
                    "Error Rate",
                    f"{metrics['error_rate']:.3f}%",
                    delta=f"{metrics['error_change']:+.3f}%"
                )

        def render_drift_analysis(self, model_name: str):
            """Render model and data drift analysis"""

            st.subheader("Drift Analysis")

            # Get drift data
            drift_data = self.get_drift_data(model_name)

            # Create drift heatmap
            fig = px.imshow(
                drift_data['feature_drift_matrix'],
                x=drift_data['time_labels'],
                y=drift_data['feature_names'],
                color_continuous_scale='RdYlBu_r',
                title="Feature Drift Heatmap"
            )

            st.plotly_chart(fig, use_container_width=True)

            # Drift summary
            critical_drift = len([
                f for f, score in drift_data['current_drift'].items()
                if score > 0.1
            ])
            if critical_drift > 0:
                st.warning(
                    f"⚠️ {critical_drift} features showing significant drift"
                )
            else:
                st.success("✅ No significant drift detected")
    ```
  </custom-dashboard>
</dashboard-setup>

## Performance Optimization

### Inference Optimization

<performance-optimization>
  <model-optimization>
    ```python
    # Model optimization techniques
    class ModelOptimizer:
        def __init__(self):
            self.optimization_strategies = [
                'quantization',
                'pruning',
                'distillation',
                'tensorrt_optimization',
                'onnx_optimization'
            ]

        def optimize_for_inference(self, model, optimization_level: str = 'balanced'):
            """Optimize model for inference performance"""

            if optimization_level == 'aggressive':
                # Maximum optimization, may sacrifice some accuracy
                optimized_model = self.apply_aggressive_optimization(model)
            elif optimization_level == 'balanced':
                # Balance between performance and accuracy
                optimized_model = self.apply_balanced_optimization(model)
            else:
                # Conservative optimization, maintain accuracy
                optimized_model = self.apply_conservative_optimization(model)

            return optimized_model

        def apply_quantization(self, model, quantization_type: str = 'int8'):
            """Apply model quantization"""

            if quantization_type == 'int8':
                # INT8 quantization for maximum speedup
                quantized_model = torch.quantization.quantize_dynamic(
                    model,
                    {torch.nn.Linear},
                    dtype=torch.qint8
                )
            elif quantization_type == 'fp16':
                # FP16 quantization for GPU inference
                quantized_model = model.half()

            return quantized_model

        def apply_pruning(self, model, sparsity_level: float = 0.3):
            """Apply structured pruning to reduce model size"""

            import torch.nn.utils.prune as prune

            for module in model.modules():
                if isinstance(module, torch.nn.Linear):
                    prune.l1_unstructured(module, name='weight', amount=sparsity_level)
                    prune.remove(module, 'weight')

            return model

        def create_distilled_model(self, teacher_model, student_architecture,
                                   training_data, temperature: float = 3.0):
            """Create distilled model from larger teacher model"""

            student_model = student_architecture()

            # Distillation training
            optimizer = torch.optim.Adam(student_model.parameters(), lr=0.001)
            criterion = DistillationLoss(temperature=temperature)

            for epoch in range(50):  # Distillation epochs
                for batch in training_data:
                    optimizer.zero_grad()

                    # Get teacher and student predictions
                    with torch.no_grad():
                        teacher_logits = teacher_model(batch['features'])

                    student_logits = student_model(batch['features'])

                    # Calculate distillation loss
                    loss = criterion(
                        student_logits, teacher_logits, batch['targets']
                    )
                    loss.backward()
                    optimizer.step()

            return student_model
    ```
  </model-optimization>

  <serving-optimization>
    ```python
    # Inference serving optimization
    class InferenceOptimizer:
        def __init__(self):
            self.cache = RedisCache()
            self.batch_processor = BatchProcessor()

        async def optimized_predict(self,
                                     request: PredictionRequest
                                     ) -> PredictionResponse:
            """Optimized prediction with caching and batching"""

            # Check cache first
            cache_key = self.generate_cache_key(request)
            cached_result = await self.cache.get(cache_key)

            if cached_result:
                return PredictionResponse.from_cache(cached_result)

            # Add to batch for processing
            batch_id = await self.batch_processor.add_request(request)

            # Wait for batch processing or timeout
            result = await self.batch_processor.wait_for_result(
                batch_id,
                timeout=100  # 100ms timeout
            )

            # Cache result for future requests
            await self.cache.set(
                cache_key,
                result.serialize(),
                ttl=300  # 5-minute cache
            )

            return result

        def setup_model_ensemble_serving(self,
                                          models: List[torch.nn.Module]):
            """Setup optimized ensemble model serving"""

            # Load balance across models based on their strengths
            model_weights = self.calculate_model_weights(models)

            @torch.jit.script
            def ensemble_predict(features: torch.Tensor) -> torch.Tensor:
                predictions = []

                for model, weight in zip(models, model_weights):
                    pred = model(features)
                    predictions.append(pred * weight)

                return torch.stack(predictions).sum(dim=0)

            return ensemble_predict

        def optimize_gpu_utilization(self, model):
            """Optimize GPU memory and compute utilization"""

            # Enable mixed precision training
            model = model.half()  # Convert to FP16

            # Optimize memory usage
            torch.backends.cudnn.benchmark = True
            torch.backends.cudnn.enabled = True

            # Use gradient checkpointing for large models
            if hasattr(model, 'gradient_checkpointing_enable'):
                model.gradient_checkpointing_enable()

            return model
    ```
  </serving-optimization>

  <resource-optimization>
    ```yaml
    # Kubernetes resource optimization
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: ml-inference-service
    spec:
      replicas: 3
      strategy:
        type: RollingUpdate
        rollingUpdate:
          maxUnavailable: 1
          maxSurge: 1
      template:
        spec:
          containers:
          - name: ml-service
            image: claude-ml:latest
            resources:
              requests:
                memory: "2Gi"
                cpu: "1000m"
                nvidia.com/gpu: "1"
              limits:
                memory: "4Gi"
                cpu: "2000m"
                nvidia.com/gpu: "1"
            env:
            - name: BATCH_SIZE
              value: "32"
            - name: MAX_WORKERS
              value: "4"
            - name: ENABLE_CACHING
              value: "true"
            readinessProbe:
              httpGet:
                path: /health
                port: 8080
              initialDelaySeconds: 30
              periodSeconds: 10
            livenessProbe:
              httpGet:
                path: /health
                port: 8080
              initialDelaySeconds: 60
              periodSeconds: 30
          nodeSelector:
            node-type: gpu-optimized
          tolerations:
          - key: nvidia.com/gpu
            operator: Equal
            value: present
            effect: NoSchedule

    ---
    apiVersion: autoscaling/v2
    kind: HorizontalPodAutoscaler
    metadata:
      name: ml-inference-hpa
    spec:
      scaleTargetRef:
        apiVersion: apps/v1
        kind: Deployment
        name: ml-inference-service
      minReplicas: 3
      maxReplicas: 20
      metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 70
      - type: Resource
        resource:
          name: memory
          target:
            type: Utilization
            averageUtilization: 80
      - type: Pods
        pods:
          metric:
            name: prediction_queue_depth
          target:
            type: AverageValue
            averageValue: "10"
      behavior:
        scaleUp:
          stabilizationWindowSeconds: 60
          policies:
          - type: Percent
            value: 100
            periodSeconds: 15
        scaleDown:
          stabilizationWindowSeconds: 300
          policies:
          - type: Percent
            value: 10
            periodSeconds: 60
    ```
  </resource-optimization>
</performance-optimization>

## Troubleshooting and Maintenance

### Common Issues and Solutions

<troubleshooting>
  <training-issues>
    <issue category="training-pipeline" severity="high">
      <problem>Model training jobs failing due to out-of-memory errors</problem>
      <symptoms>

```text
- Training jobs killed by Kubernetes OOMKiller
- CUDA out of memory errors
- Slow training performance
```

      </symptoms>
      <solutions>
        <solution priority="1">
          **Reduce batch size and implement gradient accumulation:**

```python
# Gradient accumulation to maintain effective batch size
accumulation_steps = 4
effective_batch_size = batch_size * accumulation_steps

optimizer.zero_grad()
for i, batch in enumerate(data_loader):
    loss = model(batch) / accumulation_steps
    loss.backward()

    if (i + 1) % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad()
```

        </solution>
        <solution priority="2">
          **Enable gradient checkpointing and mixed precision:**

```python
# Mixed precision training
scaler = torch.cuda.amp.GradScaler()

with torch.cuda.amp.autocast():
    outputs = model(inputs)
    loss = criterion(outputs, targets)

scaler.scale(loss).backward()
scaler.step(optimizer)
scaler.update()
```

        </solution>
      </solutions>
    </issue>

    <issue category="data-pipeline" severity="medium">
      <problem>Feature engineering pipeline producing inconsistent results</problem>
      <symptoms>

```text
- Model performance varies between training and serving
- Feature distribution mismatches
- Unexpected null values in features
```

      </symptoms>
      <solutions>
        <solution priority="1">
          **Implement feature validation with Great Expectations:**

```python
# Add comprehensive feature validation
suite = context.create_expectation_suite("feature_validation")

# Validate feature ranges
batch.expect_column_values_to_be_between("cpu_usage", 0, 100)
batch.expect_column_values_to_not_be_null("timestamp")

# Validate feature distributions
batch.expect_column_kl_divergence_to_be_less_than(
    "memory_usage", reference_distribution, threshold=0.1
)
```

        </solution>
      </solutions>
    </issue>
  </training-issues>

  <serving-issues>
    <issue category="inference-serving" severity="high">
      <problem>High prediction latency affecting real-time performance</problem>
      <solutions>
        <solution priority="1">
          **Enable prediction caching and optimize batch processing:**

```python
# Implement intelligent caching strategy
@cached(
    ttl=300,
    key_func=lambda req: hash(str(sorted(req.features.items())))
)
async def predict_with_cache(request: PredictionRequest):
    return await model.predict(request)

# Optimize batch processing
async def batch_predict(requests: List[PredictionRequest]):
    # Group similar requests
    batches = group_requests_by_similarity(requests)

    # Process batches in parallel
    results = await asyncio.gather(*[
        process_batch(batch) for batch in batches
    ])

    return flatten_results(results)
```
        </solution>
      </solutions>
    </issue>
  </serving-issues>
</troubleshooting>

### Maintenance Procedures

<maintenance-procedures>
  <routine-maintenance>
    ```bash
    #!/bin/bash
    # Weekly maintenance script

    echo "Starting ML system maintenance..."

    # 1. Update model training data
    python scripts/update-training-data.py --days=7

    # 2. Retrain models if drift detected
    drift_score=$(python scripts/check-model-drift.py --threshold=0.1)
    if [ "$drift_score" -gt "0.1" ]; then
        echo "Significant drift detected, triggering retraining..."
        python ml-pipeline/retrain-models.py --auto-deploy
    fi

    # 3. Clean up old model artifacts
    python scripts/cleanup-model-artifacts.py --keep-last=5

    # 4. Update feature store
    python scripts/refresh-feature-store.py

    # 5. Generate health report
    python scripts/generate-health-report.py --email=ops@company.com

    echo "Maintenance completed successfully"
    ```
  </routine-maintenance>

  <disaster-recovery>
    ```python
    # Disaster recovery procedures
    class DisasterRecoveryManager:
        def __init__(self):
            self.backup_locations = [
                's3://ml-backups-primary/',
                's3://ml-backups-secondary/',
                'gcs://ml-backups-dr/'
            ]

        def execute_disaster_recovery(self, recovery_type: str):
            """Execute disaster recovery procedures"""

            if recovery_type == 'model_corruption':
                self.recover_from_model_corruption()
            elif recovery_type == 'data_loss':
                self.recover_from_data_loss()
            elif recovery_type == 'infrastructure_failure':
                self.recover_from_infrastructure_failure()

        def recover_from_model_corruption(self):
            """Recover from corrupted model artifacts"""

            # 1. Identify last known good model version
            last_good_version = self.model_registry.get_last_stable_version()

            # 2. Restore model artifacts from backup
            self.restore_model_artifacts(last_good_version)

            # 3. Redeploy to serving infrastructure
            self.deployment_manager.deploy_model(last_good_version)

            # 4. Verify deployment success
            self.verify_model_serving()

        def backup_critical_components(self):
            """Backup all critical ML components"""

            components_to_backup = [
                'model_artifacts',
                'feature_store_data',
                'training_data',
                'configuration_files',
                'deployment_manifests'
            ]

            for component in components_to_backup:
                for location in self.backup_locations:
                    self.backup_component(component, location)
    ```
  </disaster-recovery>
</maintenance-procedures>

---

<operational-runbook>
  <emergency-procedures>
    <procedure name="model-serving-outage">
      <steps>

```text
1. Check service health endpoints
2. Review recent deployments and rollback if necessary
3. Scale up inference service replicas
4. Enable fallback prediction service
5. Alert stakeholders and create incident
```

      </steps>
      <contact-info>

```text
- Primary: ML Platform Team (Slack: #ml-platform)
- Secondary: DevOps Team (PagerDuty escalation)
- Executive: VP Engineering (for P0 incidents)
```

      </contact-info>
    </procedure>

    <procedure name="model-accuracy-degradation">
      <steps>

```text
1. Verify monitoring data accuracy
2. Check for data pipeline issues
3. Analyze feature drift reports
4. Initiate emergency model retraining
5. Prepare rollback to previous stable version
```

      </steps>
      <automation>

```text
- Automatic rollback if accuracy drops below 85%
- Emergency retraining triggered at 90% accuracy
- Stakeholder notifications sent automatically
```

      </automation>
    </procedure>
  </emergency-procedures>
</operational-runbook>

## MLOps Guide v1.0 - Enterprise Production Operations
