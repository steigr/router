module Router
  module Template
    Http=<<EO_HTTP_SERVICE_TEMPLATE
upstream <%= Digest::MD5.hexdigest(listener.to_s) %> {
  hash $remote_addr consistent;<% upstreams.each do |upstream| %>
  server <%= upstream.host %>:<%= upstream.port %>;<% end %>
}
server {
  listen <%= listener.port %>;
  listen [::]:<%= listener.port %>;
  server_name <%= listener.host %>;
  access_log /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_access.log;
  error_log  /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_error.log debug;
  root /dev/null;
  location / {
    proxy_pass <%= listener.scheme %>://<%= Digest::MD5.hexdigest(listener.to_s) %>;
    proxy_set_header X-Real-IP  $remote_addr;
    proxy_set_header X-Forwarded-For $remote_addr;
    proxy_set_header Host <%= listener.host %>;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
  }
}
EO_HTTP_SERVICE_TEMPLATE
    Mail=<<-EO_MAIL_SERVICE_TEMPLATE
# upstream <%= Digest::MD5.hexdigest(listener.to_s) %> {
#   hash $remote_addr consistent;<% upstreams.each do |upstream| %>
#   server <%= upstream.host %>:<%= upstream.port %>;<% end %>
# }
# server {
#   listen <%= listener.port %>; 
#   listen [::]:<%= listener.port %>;
#   access_log /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_access.log;
#   error_log  /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_error.log debug;
#   proxy_pass <%= Digest::MD5.hexdigest(listener.to_s) %>;
# }
EO_MAIL_SERVICE_TEMPLATE
    Stream=<<-EO_STREAM_SERVICE_TEMPLATE
upstream <%= Digest::MD5.hexdigest(listener.to_s) %> {
  hash $remote_addr consistent;<% upstreams.each do |upstream| %>
  server <%= upstream.host %>:<%= upstream.port %>;<% end %>
}
server {
  listen <%= listener.port %>; 
  listen [::]:<%= listener.port %>;
  access_log /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_access.log;
  error_log  /tmp/<%= listener.host %>_<%= listener.port %>.<%= listener.scheme %>_error.log debug;
  proxy_connect_timeout 1s;
  proxy_timeout 3s;
  proxy_pass <%= Digest::MD5.hexdigest(listener.to_s) %>;
}
EO_STREAM_SERVICE_TEMPLATE
  end
end