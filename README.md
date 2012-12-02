s3_storage
=========

for s3 storage

## start sinatra app

    rackup -I . -p 3000
    or
    unicorn -c unicorn.conf -I . -p 3000

## API
### GET

    curl -X GET localhost:3000/1/2/hoge.jpeg

### PUT
* resourse : world_id/file_id/file_name

        curl -X PUT --upload-file hoge.jpeg localhost:3000/1/2/hoge.jpeg

### DELETE

    curl -X DELETE localhost:3000/1/2/hoge.jpeg



