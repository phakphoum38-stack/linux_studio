class PredictiveRender {
  double latencyEstimateMs = 16;

  bool shouldSkipFrame() {
    
    return latencyEstimateMs > 20;
  }

  void updateLatency(double ms) {
    latencyEstimateMs = ms;
  }
}
