require 'helper'

class SecurelogParserOutputTest < Test::Unit::TestCase

  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    tag secure
  ]

  def create_driver(conf = CONFIG)
    Fluent::Test::OutputTestDriver.new(Fluent::SecurelogParserOutput).configure(conf)
  end

  def test_emit
    d = create_driver

    d.run do
      d.emit('message' => "Jan 17 02:47:59 hostname sshd[10654]: Received disconnect from 192.0.2.100: 11: Bye Bye")
      d.emit('message' => "Jan 17 10:00:34 hostname sudo: example: TTY=pts/00 ; PWD=/home/example ; USER=root ; COMMAND=ls")
      d.emit('message' => "Jan 17 10:31:29 hostname sshd[13352]: Accepted publickey for example from 192.0.2.100 port 55555 ssh2")
    end

  end
end
