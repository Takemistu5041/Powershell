# jma-receipt-docker

[����W�����Z�v�g�\�t�g(ORCA)](https://www.orca.med.or.jp/receipt)��Docker�R���e�i��Ŏ��s���܂��B

[PUSH�ʒm�@�\](https://www.orca.med.or.jp/receipt/tec/push-api)�����p�\�ł��B

- PUSH�ʒm�@�\(jma-receipt-pusher)
- �����ZPUSH�ʒm�쓮�t���[�����[�N(push-exchanger)

## �g�p���@

### �ꎞ�I�ȗ��p�̏ꍇ

```console
docker pull harukats/jma-receipt
docker run -p 8000:8000 harukats/jma-receipt
```

[ORCAMO�N���C�A���g(monsiaj)](https://www.orca.med.or.jp/receipt/download/java-client2/)��
`http://localhost:8000/rpc` �ɐڑ����Ă��������B

ormaster���[�U�̃f�t�H���g�p�X���[�h��`ormaster`�ł��B

### �f�[�^�x�[�X�̃f�[�^��ێ�����ꍇ

```console
git clone https://github.com/harukats/jma-receipt-docker jma-receipt
cd jma-receipt
docker-compose up
```

docker-compose.yml��K�X�J�X�^�}�C�Y���Ďg�p���Ă��������B
