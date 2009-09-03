# stew

## Description:

Cook up some AMQP recipes.

## Usage:

    server = Stew::Server::Base.new do
      queue :example, :skip => true do
        fanout :alerts do |info, payload|
          puts "Received alert #{payload.inspect}"
        end

        topic :errors, :skip => true do
          key :fatal do |info, payload|
            puts "Received fatal error #{payload.inspect}"
          end
        end
      end

      queue :other do |info, payload|
        puts "I listen to the other queue"
      end
    end

    server.run

## License:

(The MIT License)

Copyright (c) 2009 Dylan Egan

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the 'Software'), to deal in
the Software without restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWAge, publish, distribute, sublicense, and/or sell
