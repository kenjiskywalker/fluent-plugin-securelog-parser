# -*- coding: utf-8 -*-
class Fluent::SecurelogParserOutput < Fluent::Output
  Fluent::Plugin.register_output('securelog-parser', self)

  # tagを書き換えたいので
  config_param :tag, :string

  def initialize
    super

    #インスタンス変数の初期化はここかな
    @regexp = /(?<host>[^ ]+) (?<process>[^:]+): (?<key>[^*]+).*/

    # DATEフォーマット指定しておくとRegexpParserでパースする時に時間のパースをしなくて良いので有り難い
    # 参考：http://oboerutech.blog16.fc2.com/blog-entry-49.html
    @time_format = '%b %d %H%H:%M:%S'
  end

  def configure(conf)
    super
  end

  def start
    super

    @parser = Fluent::TextParser::RegexpParser.new(@regexp, 'time_format' => @time_format)
  end

  def shutdown
    super
  end

  def log_parse(value)

    # value           => "# Jan 17 02:47:59 hostname sshd[10654]: Received disconnect from 0.0.0.0: 11: Bye Bye"

    #parser = Fluent::TextParser::RegexpParser.new(@regexp, 'time_format' => @time_format)

    parsed_value = @parser.call(value)
    # parsed_value    => [1358437767, {"host"=>"02:47:59", "process"=>"hostname sshd[10654]", "key"=>"Received disconnect from 0.0.0.0: 11: Bye Bye"}]

    parsed_value[1]['key']
    # parsed_value[0] => "1358437767"
    # @securelog      => "Received disconnect from 0.0.0.0: 11: Bye Bye"
  end

  def emit(tag, es, chain)
    es.each do |time,record|

      #recordの中身をkey, valueで分けない方法考えたい
      record.each do |key,value|
        message = log_parse(value)

        #ここがアレ
        record = {"message" => message}

        Fluent::Engine.emit(@tag, time, record)
      end
    end

    chain.next
  end
end
