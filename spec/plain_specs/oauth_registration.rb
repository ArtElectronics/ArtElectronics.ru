ENV["RAILS_ENV"] ||= 'development'
require File.expand_path("../../../config/environment", __FILE__)

def create_user_without_oauth
   puts "Without OAUTH"
   user = User.create
   puts user.errors.to_a
end

def create_user_with_facebook_oauth
   # Facebook
   json_data = '{
      "provider":"facebook",
      "uid":"100100100",
      "info":{
         "email":"killich@ya.ru",
         "name":"Илья Зыкин",
         "first_name":"Илья",
         "last_name":"Зыкин",
         "image":"http://graph.facebook.com/10202934219094389/picture&redirect=false",
         "urls":{
            "Facebook":"https://www.facebook.com/app_scoped_user_id/100100100/"
         },
         "verified":true
      },
      "credentials":{
         "token":"my_tocken1000",
         "expires_at":1405950180,
         "expires":true
      },
      "extra":{
         "raw_info":{
            "id":"100100100",
            "email":"killich@ya.ru",
            "first_name":"Илья",
            "gender":"male",
            "last_name":"Зыкин",
            "link":"https://www.facebook.com/app_scoped_user_id/100100100/",
            "locale":"ru_RU",
            "name":"Илья Зыкин",
            "timezone":4,
            "updated_time":"2014-05-22T12:14:08+0000",
            "verified":true
         }
      }
   }'

   puts "With OAUTH"
   user = User.create(oauth_data: json_data)
   puts user.errors.to_a
end

def create_user_with_vk_oauth
   # VKONTAKTE
   json_data = '{
      "provider":"vkontakte",
      "uid":"100100100",
      "info":{
         "name":"Илья Николаевич",
         "nickname":"",
         "first_name":"Илья",
         "last_name":"Николаевич",
         "image":"http://cs304109.vk.me/v304109742/605e/mgMMsogBxLo.jpg",
         "location":"Россия, Санкт-Петербург",
         "urls":{
            "Vkontakte":"http://vk.com/izzizzi"
         }
      },
      "credentials":{
         "token":"test_token",
         "expires_at":1400935708,
         "expires":true
      },
      "extra":{
         "raw_info":{
            "id":100100100,
            "first_name":"Илья",
            "last_name":"Николаевич",
            "sex":2,
            "nickname":"",
            "screen_name":"izzizzi",
            "bdate":"2.11.1984",
            "city":2,
            "country":1,
            "photo_50":"http://cs304109.vk.me/v304109742/605e/mgMMsogBxLo.jpg",
            "photo_100":"http://cs304109.vk.me/v304109742/605d/JNedY0oKESs.jpg",
            "photo_200_orig":"http://cs304109.vk.me/v304109742/605b/AQrtEvxwZnM.jpg",
            "online":1
         }
      }
   }'

   puts "With OAUTH"
   user = User.create(oauth_data: json_data)
   puts user.errors.to_a
end

def create_user_with_twitter_oauth
   json_data = '{
      "provider":"twitter",
      "uid":"100100100",
      "info":{
         "nickname":"iam_teacher",
         "name":"Илья Николаевич",
         "location":"Питер",
         "image":"http://pbs.twimg.com/profile_images/378800000801642062/07c6d6e7df7acc665af54172fb98494b_normal.jpeg",
         "description":"Dreams on Rails",
         "urls":{
            "Website":"http://t.co/XE1VRDZXwr",
            "Twitter":"https://twitter.com/iam_teacher"
         }
      },
      "credentials":{
         "token":"100100100-rHs4Yz9LPkhMEBXyeZxLWdfMZ6Qf30ySl40WaQs",
         "secret":"e0UGMv4zsf2yit7TLpPoyZ0gHknWjtSn4u2jvkfDI12fW"
      },
      "extra":{
         "access_token":{
            "token":"100100100-rHs4Yz9LPkhMEBXyeZxLWdfMZ6Qf30ySl40WaQs",
            "secret":"e0UGMv4zsf2yit7TLpPoyZ0gHknWjtSn4u2jvkfDI12fW",
            "consumer":{
               "key":"nOLguvZ6NFj142AUc4s1TZhby",
               "secret":"ujWEH7rKF39EoTnJxzAHNx3dapaBzqQK67LDVd4ROP2AyaiYa8",
               "options":{
                  "signature_method":"HMAC-SHA1",
                  "request_token_path":"/oauth/request_token",
                  "authorize_path":"/oauth/authenticate",
                  "access_token_path":"/oauth/access_token",
                  "proxy":null,
                  "scheme":"header",
                  "http_method":"post",
                  "oauth_version":"1.0",
                  "site":"https://api.twitter.com"
               },
               "http":{
                  "address":"api.twitter.com",
                  "port":443,
                  "local_host":null,
                  "local_port":null,
                  "curr_http_version":"1.1",
                  "keep_alive_timeout":2,
                  "last_communicated":null,
                  "close_on_empty_response":false,
                  "socket":null,
                  "started":false,
                  "open_timeout":30,
                  "read_timeout":30,
                  "continue_timeout":null,
                  "debug_output":null,
                  "proxy_from_env":true,
                  "proxy_uri":null,
                  "proxy_address":null,
                  "proxy_port":null,
                  "proxy_user":null,
                  "proxy_pass":null,
                  "use_ssl":true,
                  "ssl_context":{
                     "cert":null,
                     "key":null,
                     "client_ca":null,
                     "ca_file":null,
                     "ca_path":null,
                     "timeout":null,
                     "verify_mode":0,
                     "verify_depth":null,
                     "renegotiation_cb":null,
                     "verify_callback":null,
                     "options":-2147482625,
                     "cert_store":null,
                     "extra_chain_cert":null,
                     "client_cert_cb":null,
                     "tmp_dh_callback":null,
                     "session_id_context":null,
                     "session_get_cb":null,
                     "session_new_cb":null,
                     "session_remove_cb":null,
                     "servername_cb":null,
                     "npn_protocols":null,
                     "npn_select_cb":null
                  },
                  "ssl_session":{

                  },
                  "enable_post_connection_check":true,
                  "sspi_enabled":false,
                  "ca_file":null,
                  "ca_path":null,
                  "cert":null,
                  "cert_store":null,
                  "ciphers":null,
                  "key":null,
                  "ssl_timeout":null,
                  "ssl_version":null,
                  "verify_callback":null,
                  "verify_depth":null,
                  "verify_mode":0
               },
               "http_method":"post",
               "uri":{
                  "scheme":"https",
                  "user":null,
                  "password":null,
                  "host":"api.twitter.com",
                  "port":443,
                  "path":"",
                  "query":null,
                  "opaque":null,
                  "registry":null,
                  "fragment":null,
                  "parser":null
               }
            },
            "params":{
               "oauth_token":"100100100-rHs4Yz9LPkhMEBXyeZxLWdfMZ6Qf30ySl40WaQs",
               "oauth_token_secret":"e0UGMv4zsf2yit7TLpPoyZ0gHknWjtSn4u2jvkfDI12fW",
               "user_id":"100100100",
               "screen_name":"iam_teacher"
            },
            "response":{
               "cache-control":[
                  "no-cache, no-store, must-revalidate, pre-check=0, post-check=0"
               ],
               "content-length":[
                  "653"
               ],
               "content-type":[
                  "application/json;charset=utf-8"
               ],
               "date":[
                  "Fri, 23 May 2014 12:56:48 GMT"
               ],
               "expires":[
                  "Tue, 31 Mar 1981 05:00:00 GMT"
               ],
               "last-modified":[
                  "Fri, 23 May 2014 12:56:48 GMT"
               ],
               "pragma":[
                  "no-cache"
               ],
               "server":[
                  "tfe"
               ],
               "set-cookie":[
                  "lang=ru",
                  "guest_id=v1%3A140084980831930062; Domain=.twitter.com; Path=/; Expires=Sun, 22-May-2016 12:56:48 UTC"
               ],
               "status":[
                  "200 OK"
               ],
               "strict-transport-security":[
                  "max-age=631138519"
               ],
               "x-access-level":[
                  "read"
               ],
               "x-content-type-options":[
                  "nosniff"
               ],
               "x-frame-options":[
                  "SAMEORIGIN"
               ],
               "x-rate-limit-limit":[
                  "15"
               ],
               "x-rate-limit-remaining":[
                  "14"
               ],
               "x-rate-limit-reset":[
                  "1400850708"
               ],
               "x-transaction":[
                  "b072b432de4625c6"
               ],
               "x-xss-protection":[
                  "1; mode=block"
               ],
               "connection":[
                  "close"
               ]
            }
         },
         "raw_info":{
            "id":100100100,
            "id_str":"100100100",
            "name":"Илья Николаевич",
            "screen_name":"iam_teacher",
            "location":"Питер",
            "description":"Dreams on Rails",
            "url":"http://t.co/XE1VRDZXwr",
            "entities":{
               "url":{
                  "urls":[
                     {
                        "url":"http://t.co/XE1VRDZXwr",
                        "expanded_url":"http://open-cook.ru",
                        "display_url":"open-cook.ru",
                        "indices":[
                           0,
                           22
                        ]
                     }
                  ]
               },
               "description":{
                  "urls":[

                  ]
               }
            },
            "protected":false,
            "followers_count":17,
            "friends_count":43,
            "listed_count":0,
            "created_at":"Sat Sep 21 19:26:54 +0000 2013",
            "favourites_count":1,
            "utc_offset":null,
            "time_zone":null,
            "geo_enabled":false,
            "verified":false,
            "statuses_count":45,
            "lang":"ru",
            "contributors_enabled":false,
            "is_translator":false,
            "is_translation_enabled":false,
            "profile_background_color":"C0DEED",
            "profile_background_image_url":"http://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_image_url_https":"https://abs.twimg.com/images/themes/theme1/bg.png",
            "profile_background_tile":false,
            "profile_image_url":"http://pbs.twimg.com/profile_images/378800000801642062/07c6d6e7df7acc665af54172fb98494b_normal.jpeg",
            "profile_image_url_https":"https://pbs.twimg.com/profile_images/378800000801642062/07c6d6e7df7acc665af54172fb98494b_normal.jpeg",
            "profile_link_color":"0084B4",
            "profile_sidebar_border_color":"C0DEED",
            "profile_sidebar_fill_color":"DDEEF6",
            "profile_text_color":"333333",
            "profile_use_background_image":true,
            "default_profile":true,
            "default_profile_image":false,
            "following":false,
            "follow_request_sent":false,
            "notifications":false
         }
      }
   }'

   puts "With OAUTH"
   user = User.create(oauth_data: json_data)
   puts user.errors.to_a
end

def create_user_with_google_oauth
   json_data = '{
      "provider":"google_oauth2",
      "uid":"100100100",
      "info":{
         "name":"Илья Николаевич",
         "email":"gkillich@gmail.com",
         "first_name":"Илья",
         "last_name":"Николаевич",
         "image":"https://lh6.googleusercontent.com/-_4nOVdM7f7U/AAAAAAAAAAI/AAAAAAAAAEE/ju9NEnysXHw/s50/photo.jpg?sz=50",
         "urls":{
            "Google":"https://plus.google.com/100100100"
         }
      },
      "credentials":{
         "token":"token",
         "expires_at":1400854629,
         "expires":true
      },
      "extra":{
         "id_token":"tken--J0kytfs",
         "raw_info":{
            "kind":"plus#personOpenIdConnect",
            "gender":"male",
            "sub":"100100100",
            "name":"Илья Николаевич",
            "given_name":"Илья",
            "family_name":"Николаевич",
            "profile":"https://plus.google.com/100100100",
            "picture":"https:https://lh6.googleusercontent.com/-_4nOVdM7f7U/AAAAAAAAAAI/AAAAAAAAAEE/ju9NEnysXHw/photo.jpg?sz=50",
            "email":"gkillich@gmail.com",
            "email_verified":"true",
            "locale":"ru"
         }
      }
   }'

   puts "With OAUTH"
   user = User.create(oauth_data: json_data)
   puts user.errors.to_a
end

# create_user_without_oauth
create_user_with_facebook_oauth
create_user_with_vk_oauth
create_user_with_twitter_oauth
create_user_with_google_oauth

