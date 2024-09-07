module RequestHeaderHandler
  extend ActiveSupport::Concern

  def cloudfront_headers
    @cloudfront_headers ||= {
      cloudfront_viewer_address:             request.headers['CloudFront-Viewer-Address'],
      cloudfront_viewer_country:             request.headers['CloudFront-Viewer-Country'],
      cloudfront_is_ios_viewer:              request.headers['CloudFront-Is-Ios-Viewer'],
      cloudfront_is_tablet_viewer:           request.headers['CloudFront-Is-Tablet-Viewer'],
      cloudfront_viewer_country_name:        request.headers['CloudFront-Viewer-Country-Name'],
      cloudfront_is_mobile_viewer:           request.headers['CloudFront-Is-Mobile-Viewer'],
      cloudfront_is_smarttv_viewer:          request.headers['CloudFront-Is-Smarttv-Viewer'],
      cloudfront_viewer_country_region:      request.headers['CloudFront-Viewer-Country-Region'],
      cloudfront_is_android_viewer:          request.headers['CloudFront-Is-Android-Viewer'],
      cloudfront_viewer_country_region_name: request.headers['CloudFront-Viewer-Country-Region-Name'],
      cloudfront_viewer_city:                request.headers['CloudFront-Viewer-City'],
      cloudfront_viewer_latitude:            request.headers['CloudFront-Viewer-Latitude'],
      cloudfront_viewer_longitude:           request.headers['CloudFront-Viewer-Longitude'],
      cloudfront_viewer_postal_code:         request.headers['CloudFront-Viewer-Postal-Code'],
      cloudfront_is_desktop_viewer:          request.headers['CloudFront-Is-Desktop-Viewer']
    }
  end

  def device_headers
    @device_headers ||= {
      app_version:       request.headers['HTTP_X_APP_VERSION'],
      platform:          request.headers['HTTP_X_PLATFORM'],
      device_model:      request.headers['HTTP_X_DEVICE_MODEL'],
      os_version:        request.headers['HTTP_X_OS_VERSION'],
      app_build_version: request.headers['HTTP_X_APP_BUILD_VERSION'],
      device_token:      request.headers['HTTP_X_DEVICE_TOKEN'],
      user_timezone:     request.headers['HTTP_X_USER_TIMEZONE']
    }
  end
end
