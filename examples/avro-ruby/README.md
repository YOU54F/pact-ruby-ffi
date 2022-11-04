Avro Ruby
========================

http://hadooptutorial.info/avro-serialization-ruby-example/

1. `bundle add avro`
2. `touch items.avsc`

```json
{
 "type" : "record",
 "name" : "Item",
 "namespace" : "example.avro",
 "fields" : [
              {"name": "name", "type": "string"},
              {"name": "description", "type":["string", "null"]},
              {"name": "price", "type":["double", "null"]}
            ]
}
```


3. `touch generate_data.rb`

```rb
# Equivalant to importing required packages in Java
require 'rubygems'
require 'avro'
 
# Below line creates items.avro file if it is not present otherwise opens it in write mode
file = File.open('items.avro', 'wb')  
 
# Opens item.avsc in read mode and parses the schema.
schema = Avro::Schema.parse(File.open("item.avsc", "rb").read)
 
# Creates DatumWriter instance with required schema.
writer = Avro::IO::DatumWriter.new(schema)
 
# Below dw is equivalent to DataFileWriter instance in Java API
dw = Avro::DataFile::Writer.new(file, writer, schema)
 
# write each record into output avro data file
dw<< {"name" => "Desktop", "description" => "Office and Personal Usage", "price" => 30000}
dw<< {"name" => "Laptop", "price" => 50000}
dw<< {"name" => "Tablet", "description" => "Personal Usage"}
dw<< {"name" => "Mobile", "description" => "Personal Usage", "price" => 10000}
dw<< {"name" => "Notepad", "price" => 20000}
dw<< {"name" => "SmartPhone", "description" => "Multipurpose", "price" => 40000}
 
# close the avro data file
dw.close
```

4. `ruby generate_data.rb`
5. Download jar https://mvnrepository.com/artifact/org.apache.avro/avro-tools/1.11.1
6. `java -jar avro-tools-1.11.1.jar tojson items.avro`

7. `touch read_data.rb`

```rb
require 'rubygems'
require 'avro'
 
# Open items.avro file in read mode
file = File.open('items.avro', 'rb')
 
# Create an instance of DatumReader 
reader = Avro::IO::DatumReader.new()
 
# Equivalent to DataFileReader instance creation in Java
dr = Avro::DataFile::Reader.new(file, reader)
 
# For each record type in the input file prints the fields mentioned 
# in print command on console. Each output field is tab seperated 
dr.each {|record|
         print record["name"],"\t",record["description"],"\t",record["price"],"\n"
        }
 
# Close the input file
dr.close
```

8.  `ruby read_data.rb`
