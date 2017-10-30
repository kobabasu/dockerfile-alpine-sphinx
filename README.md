# dockerfile-alpine-chrome

```
git submodule add git@github.com-kobabasu:kobabasu/dockerfile-alpine-chrome.git repo
```

## vagrant
1. `hub clone coreos/coreos-vagrant coreos`
1. `cd coreos`
1. 必要なファイルをリネーム  
   * `mv config.rb.sample config.rb`
1. config.rb編集  
    以下の2箇所を変更
    * `$instance_name_prefix="chrome"`
    * `$shared_folders = {'../repo/' => '/home/core/share'}`
1. `vagrant up`

## build
1. `docker build -t kobabasu/alpine-chrome:0.01 /home/core/share`
1. `docker run --name sphinx -v /home/core/share:/app -d kobabasu/alpine-chrome:0.01`
1. `docker exec -it sphinx /bin/sh`

## docker hub
1. `docker login`
1. `docker push kobabasu/alpine-chrome:0.01`
