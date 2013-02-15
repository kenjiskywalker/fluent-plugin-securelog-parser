# Fluent::Plugin::Securelog::Parser

## Configuration

### 参考

[fluentdのプラグインを書く練習をする為にsecureログをparseしてZabbixで値が取得できるようにしてみた(作成編)](http://blog.kenjiskywalker.org/blog/2013/01/20/fluentd-plugin-create-newbiee/)  
[fluentdのプラグインを書く練習をする為にsecureログをparseしてZabbixで値が取得できるようにしてみた(設定編)](http://blog.kenjiskywalker.org/blog/2013/01/20/fluentd-plugin-create-newbie/)

### 設定例

`/etc/fluent-agent-lite.conf`
```
TAG_PREFIX=""
LOGS=$(cat <<"EOF"
secure                   /var/log/secure
EOF
)
PRIMARY_SERVER="0.0.0.0:24224"
```

`/etc/td-agent/td-agent.conf`
```
<source>
  type forward
  port 24224
</source>

<match secure>
  type securelog-parser
  tag  seclog.local
</match>

<match seclog.*>
  type copy
   <store>
    type datacounter
    count_key message
    aggregate all
    tag check.seclog
    pattern1 acce Accepted
    pattern2 fail failure
    pattern3 inva Invalid
  </store>
  <store>
   type file
   path /tmp/hoge
  </store>
</match>
```



TODO: Write a gem description

## Installation(no gem update)

Add this line to your application's Gemfile:

    gem 'fluent-plugin-securelog-parser'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-securelog-parser

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
