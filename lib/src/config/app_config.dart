enum Environment { DEV, UAT, PREPROD, TRAINING, RELEASE }

class AppConfig {
  late Environment environment;
  late Map<String, dynamic> _config;

  String get baseUrl => _config[_Config.BASE_URL];
  String get uploadUrl => _config[_Config.UPLOAD_URL];
  String get uploadListingUrl => _config[_Config.UPLOAD_LISTING_URL];
  String get coreUrl => _config[_Config.API_CORE_URL];
  String get coreUrlFE => _config[_Config.FE_CORE_URL];
  String get propzyMapURL => _config[_Config.PROPZY_MAP_iBUY_URL];
  String get portalURL => _config[_Config.PORTAL_URL];
  String get chatWithCSURL => _config[_Config.CHAT_WITH_CS_URL];
  String get trackingUrl => _config[_Config.TRACKING_URL];
  String get trackingServiceId => _config[_Config.TRACKING_SERVICE_ID];

  AppConfig(this.environment) {
    switch (environment) {
      case Environment.DEV:
        _config = _Config.devConstants;
        break;
      case Environment.UAT:
        _config = _Config.uatConstants;
        break;
      case Environment.PREPROD:
        _config = _Config.preprodConstants;
        break;
      case Environment.TRAINING:
        _config = _Config.trainingConstants;
        break;
      case Environment.RELEASE:
        _config = _Config.releaseConstants;
        break;
    }
  }
}

class _Config {
  static const BASE_URL = 'BASE_URL';
  static const API_CORE_URL = 'API_CORE_URL';
  static const FE_CORE_URL = 'FE_CORE_URL';
  static const CHAT_WITH_CS_URL = 'CHAT_WITH_CS_URL';
  static const UPLOAD_URL = 'UPLOAD_URL';
  static const UPLOAD_LISTING_URL = 'UPLOAD_LISTING_URL';
  static const GOOGLE_MAP_KEY = 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4';
  static const GOOGLE_SEARCH_KEY = 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU';
  static const PROPZY_MAP_iBUY_URL = 'PROPZY_MAP_iBUY_URL';
  static const PORTAL_URL = 'PORTAL_URL';
  static const TRACKING_URL = 'TRACKING_URL';
  static const TRACKING_SERVICE_ID = 'TRACKING_SERVICE_ID';

  static Map<String, dynamic> devConstants = {
    BASE_URL: 'http://dev-flex-v1.k8s.propzy.asia/',
    API_CORE_URL: 'https://dev-core-team-v1.k8s.propzy.asia/',
    FE_CORE_URL: 'https://dev-core-team-account-v1.k8s.propzy.asia/',
    UPLOAD_URL: 'http://dev-file-api-v1.k8s.propzy.asia/file/api/upload/',
    UPLOAD_LISTING_URL: 'https://preprod-filev3-api-v1.k8s.propzy.asia/v3/file/image/upload',
    CHAT_WITH_CS_URL: 'http://staging-freshchat-v1.k8s.propzy.asia/',
    GOOGLE_MAP_KEY: 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4',
    GOOGLE_SEARCH_KEY: 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU',
    PROPZY_MAP_iBUY_URL: 'http://dev-and-microfrontends-v1.k8s.propzy.asia/components/maps?session=',
    PORTAL_URL : 'http://dev-flex-big-revamp-v1.k8s.propzy.asia/',
    TRACKING_URL: 'http://staging-tracking-service-v1.k8s.propzy.asia/tracking-service/track',
    TRACKING_SERVICE_ID: 'f188993a-22f7-4098-a6e9-3e905174514e',
  };

  static Map<String, dynamic> uatConstants = {
    BASE_URL: 'http://staging-flex-v1.k8s.propzy.asia/',
    API_CORE_URL: 'https://qc-core-team-v1.k8s.propzy.asia/',
    FE_CORE_URL: 'https://qc-core-team-account-v1.k8s.propzy.asia/',
    UPLOAD_URL: 'http://staging-file-api-v1.k8s.propzy.asia/file/api/upload/',
    UPLOAD_LISTING_URL: 'https://preprod-filev3-api-v1.k8s.propzy.asia/v3/file/image/upload',
    CHAT_WITH_CS_URL: 'http://staging-freshchat-v1.k8s.propzy.asia/',
    GOOGLE_MAP_KEY: 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4',
    GOOGLE_SEARCH_KEY: 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU',
    PROPZY_MAP_iBUY_URL: 'http://staging-and-microfrontends-v1.k8s.propzy.asia/components/maps?session=',
    PORTAL_URL : 'https://staging-flex-big-revamp-v1.k8s.propzy.asia',
    TRACKING_URL: 'http://staging-tracking-service-v1.k8s.propzy.asia/tracking-service/track',
    TRACKING_SERVICE_ID: 'f188993a-22f7-4098-a6e9-3e905174514e',
  };

  static Map<String, dynamic> trainingConstants = {
    BASE_URL: 'http://45.117.162.60:8082/',
    API_CORE_URL: 'https://qc-core-team-v1.k8s.propzy.asia/',
    FE_CORE_URL: 'https://qc-core-team-account-v1.k8s.propzy.asia/',
    UPLOAD_URL: 'http://45.117.162.49:8080/file/api/upload',
    UPLOAD_LISTING_URL: 'https://preprod-filev3-api-v1.k8s.propzy.asia/v3/file/image/upload',
    CHAT_WITH_CS_URL: 'http://staging-freshchat-v1.k8s.propzy.asia/',
    GOOGLE_MAP_KEY: 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4',
    GOOGLE_SEARCH_KEY: 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU',
    PROPZY_MAP_iBUY_URL: 'http://staging-and-microfrontends-v1.k8s.propzy.asia/components/maps?session=',
    PORTAL_URL : 'https://staging-flex-big-revamp-v1.k8s.propzy.asia/',
    TRACKING_URL: 'http://staging-tracking-service-v1.k8s.propzy.asia/tracking-service/track',
    TRACKING_SERVICE_ID: 'f188993a-22f7-4098-a6e9-3e905174514e',
  };

  static Map<String, dynamic> preprodConstants = {
    BASE_URL: 'https://preprod-ingress-v1.k8s.propzy.asia/',
    API_CORE_URL: 'https://staging-core-team-v1.k8s.propzy.asia/',
    FE_CORE_URL: 'https://staging-core-team-account-v1.k8s.propzy.asia/',
    UPLOAD_URL: 'https://preprod-file-api-v1.k8s.propzy.asia/file/api/upload/',
    UPLOAD_LISTING_URL: 'https://preprod-filev3-api-v1.k8s.propzy.asia/v3/file/image/upload',
    CHAT_WITH_CS_URL: 'http://staging-freshchat-v1.k8s.propzy.asia/',
    GOOGLE_MAP_KEY: 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4',
    GOOGLE_SEARCH_KEY: 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU',
    PROPZY_MAP_iBUY_URL: 'http://staging-and-microfrontends-v1.k8s.propzy.asia/components/maps?session=',
    PORTAL_URL : 'https://preprod-big-revamp-v1.k8s.propzy.asia/',
    TRACKING_URL: 'http://staging-tracking-service-v1.k8s.propzy.asia/tracking-service/track',
    TRACKING_SERVICE_ID: 'f188993a-22f7-4098-a6e9-3e905174514e',
  };

  static Map<String, dynamic> releaseConstants = {
    BASE_URL: 'http://microapi1.propzy.vn:9090/',
    API_CORE_URL: 'http://microapi1.propzy.vn:9090/',
    FE_CORE_URL: 'http://microapi1.propzy.vn:9090/',//TODO: Need update
    // UPLOAD_URL: 'http://cdn.propzy.vn:9090/file/api/upload/',
    UPLOAD_URL: 'http://gate.propzy.vn/file/api/upload/',
    UPLOAD_LISTING_URL: 'https://preprod-filev3-api-v1.k8s.propzy.asia/v3/file/image/upload',
    CHAT_WITH_CS_URL: 'https://propzy.vn/app/cs_chat/',
    GOOGLE_MAP_KEY: 'AIzaSyCCHLQ7hYehfF2gdrJdyK9QDfx9bHGM-W4',
    GOOGLE_SEARCH_KEY: 'AIzaSyDAKfh9wFOMZAb23fcT-26shH06pLz4FZU',
    PROPZY_MAP_iBUY_URL: 'https://eco-api.propzy.vn/components/maps?session=',
    PORTAL_URL: 'https://propzy.vn/',
    TRACKING_URL: 'http://staging-tracking-service-v1.k8s.propzy.asia/tracking-service/track',
    TRACKING_SERVICE_ID: 'f188993a-22f7-4098-a6e9-3e905174514e',
  };
}
