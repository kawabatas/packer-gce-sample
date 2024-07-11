# packer-gce-sample
GCEのVMイメージをPackerで作成するサンプル

[Packer](https://developer.hashicorp.com/packer) は HashiCorp 製の VM イメージを作成するツールです。

## 事前準備
asdf で packer をインストールしてください。

`gcloud auth login` で個人の Google アカウントで認証を済ませておいてください。

## 使い方
```bash
cd packer

# 初回のみ
packer init .

# フォーマット
packer fmt .

# バリデーション
packer validate .

# ビルド
packer build .
```

## VM作成
```bash
gcloud compute instances create kawabata-test \
  --image=kawabatas-test-imege-20240711030401 \
  --machine-type=e2-micro \
  --zone=asia-northeast1-a \
  --project=プロジェクトID \
  --tags="http-server","https-server" \
  --scopes=https://www.googleapis.com/auth/cloud-platform
```

## 参考
- [Packer を使用した VM イメージのビルド](https://cloud.google.com/build/docs/building/build-vm-images-with-packer?hl=ja)
- [Packer GCE build](https://github.com/GoogleCloudPlatform/cloud-builders-community/tree/master/packer/examples/gce)
