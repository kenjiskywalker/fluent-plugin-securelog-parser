class Fluent::SecurelogParserOutput < Fluent::Output
  Fluent::Plugin.register_output('securelog-parser', self)

  config_param :tag, :string

  def initialize
    super
    @regexp = /(?<host>[^ ]+) (?<process>[^:]+): (?<key>[^*]+).*/
    @time_format = '%b %d %H%H:%M:%S'
  end

  def configure(conf)
    super
  end

  def start
    super
  end

  def shutdown
    super
  end

  def log_parse(value)

    # value           => "# Jan 17 02:47:59 hostname sshd[10654]: Received disconnect from 0.0.0.0: 11: Bye Bye"

    parser = Fluent::TextParser::RegexpParser.new(@regexp, 'time_format' => @time_format)
    parsed_value = parser.call(value)
    # parsed_value    => [1358437767, {"host"=>"02:47:59", "process"=>"hostname sshd[10654]", "key"=>"Received disconnect from 0.0.0.0: 11: Bye Bye"}]

    @securelog = parsed_value[1]['key']
    # parsed_value[0] => "1358437767"
    # @securelog      => "Received disconnect from 0.0.0.0: 11: Bye Bye"
  end

  def emit(tag, es, chain)
    es.each do |time,record|

      record.each do |key,value|
        log_parse(value)
        record = {"message" => @securelog}
        Fluent::Engine.emit(@tag, time, record)
      end
    end

    chain.next
  end
end
