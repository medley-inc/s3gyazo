# Gyazoサーバについて
gyazoはコンテナとしてEC2上のdockerにて動作しています。
イメージはECRの
 - 050067577205.dkr.ecr.ap-northeast-1.amazonaws.com/s3gyazo
 
リポジトリにて管理しているので、更新の際はこちらのpushしてください。

## 1. 新規立ち上げ
### EC2インスタンスの新規作成
下記の設定で新規インスタンスを立ち上げる。

設定項目 | 設定内容
--- | ---
OS | Amazon Linux2
インスタンスタイプ | t2.micro
ネットワーク(vpc) | vpc-764a8d13
サブネット | subnet-0574bc72
IAMロール | gyazo-medley-inc
ストレージ | 8GB
タグ | Nameにインスタンス名
セキュリティグループ | sg-80ed86e5(gyazo-medley-inc)
キーペア | なし

### dockerのインストール
Session Managerで上記で作成したインスタンスにログインし作業を行う。

```
# Session Managerでインスタンスに入る
aws ssm start-session --target {インスタンスID}

# rootになる
sh-4.2$ sudo su
[root@ip-172-31-12-73 bin]#

# Dockerのインストールと有効化
yum -y install docker
systemctl start docker
systemctl enable docker
```

## 2. gyazoのセットアップ
1. 新規立ち上げの続きまたはgyazoのイメージを更新した場合の再起動はここの手順から
### ECRにログインしgyazoのイメージをpull
```
export AWS_DEFAULT_REGION=ap-northeast-1
`aws ecr get-login --no-include-email`
docker pull 050067577205.dkr.ecr.ap-northeast-1.amazonaws.com/s3gyazo:{イメージタグ}
```

## 3. gyazoの起動
下記コマンドにてgyazoコンテナを起動する
```
docker run -d -p 80:80 050067577205.dkr.ecr.ap-northeast-1.amazonaws.com/s3gyazo:{イメージタグ}
```

## 4. ElasticIPの紐付け
Gyazoは社内にて下記ElasticIPで運用しているので、今回のインスタンスに下記IPを関連付ける
```
52.69.223.135
```



