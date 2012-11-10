s3_strage
=========

for s3 strage

## strage sinatra app

    rackup -I . -p 3001

## API
### GET

    curl -X GET localhost:3000/1/2/hoge.jpeg

### PUT
* resourse : world_id/file_id/file_name

        curl -X PUT --upload-file hoge.jpeg localhost:3000/1/2/hoge.jpeg

### DELETE

    curl -X DELETE localhost:3000/1/2/hoge.jpeg



