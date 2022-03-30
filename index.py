# -*- coding: utf8 -*-
# SCF configures the COS trigger, obtains the file uploading information from COS, and downloads it to the local temporary disk 'tmp' of SCF.
# SCF配置COS触发，从COS获取文件上传信息，并下载到SCF的本地临时磁盘tmp，然后上传到另一个账号的某个bucket下
from qcloud_cos_v5 import CosConfig
from qcloud_cos_v5 import CosS3Client
from qcloud_cos_v5 import CosServiceError
from qcloud_cos_v5 import CosClientError
import sys
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO) # 默认打印 INFO 级别日志，可根据需要调整为 DEBUG、WARNING、ERROR、CRITICAL 级日志

src_appid = u''  # Please replace with your APPID. 请替换为您的 APPID
src_secret_id = u''  # Please replace with your SecretId. 请替换为您的 SecretId
src_secret_key = u''  # Please replace with your SecretKey. 请替换为您的 SecretKey
src_region = u'ap-beijing'  # Please replace with the region where COS bucket located. 请替换为您bucket 所在的地域
src_token = ''
src_config = CosConfig(Secret_id=src_secret_id, Secret_key=src_secret_key, Region=src_region, Token=src_token)
src_client = CosS3Client(src_config)

dst_appid = u''  # Please replace with your APPID. 请替换为您的 APPID
dst_secret_id = u''  # Please replace with your SecretId. 请替换为您的 SecretId
dst_secret_key = u''  # Please replace with your SecretKey. 请替换为您的 SecretKey
dst_region = u'ap-chengdu'  # Please replace with the region where COS bucket located. 请替换为您bucket 所在的地域
dst_token = ''
dst_bucket= u''
dst_config = CosConfig(Secret_id=dst_secret_id, Secret_key=dst_secret_key, Region=dst_region, Token=dst_token)
dst_client = CosS3Client(dst_config)

big_obj_threshold = 5 * 1024 * 1024

logger = logging.getLogger()

def show_event(event):
    logger.info("start to show_event");
    for record in event['Records']:
        try:
            print(record)       
        except Exception as e:
            print(e)
            raise e

def download_obj(client, bucket, key, local_path):
    logger.info("start to download object");
    logger.info("Get from [%s] to download file [%s]" % (bucket, key))
    try:
        response = client.get_object(Bucket=bucket, Key=key, )
        response['Body'].get_stream_to_file(local_path)
    except CosServiceError as e:
        print(e.get_error_code())
        print(e.get_error_msg())
        print(e.get_resource_location())
        raise e
    
    logger.info("Download file [%s] to [%s] Success" % (key, local_path))

def upload_obj(client, bucket, key, local_path, part_size=1, max_thread=10, enable_md5=True):
    logger.info("start to upload object")
    logger.info("Put from local file [%s] to cos [%s]" % (local_path, key))
    
    try:
        response = client.upload_file(
            Bucket=bucket,
            LocalFilePath=local_path,
            Key=key,
            PartSize=part_size,
            MAXThread=max_thread,
            EnableMD5=enable_md5
        )
        print(response)
    except CosServiceError as e:
        print(e.get_error_code())
        print(e.get_error_msg())
        print(e.get_resource_location())
        raise e
    
    logger.info("Upload local file [%s] to cos [%s] Success" % (local_path, key))

def main_handler(event, context):
    show_event(event)

    logger.info("start main handler")
    for record in event['Records']:
        try:
            src_bucket = record['cos']['cosBucket']['name'] + '-' + str(src_appid)
            key = record['cos']['cosObject']['key']
            key = key.replace('/' + str(src_appid) + '/' + record['cos']['cosBucket']['name'] + '/', '', 1)
            obj_size = record['cos']['cosObject']['size']
            logger.info("Key is " + key)

            if obj_size < big_obj_threshold:
                logger.info("Get from [%s] to download file [%s]" % (src_bucket, key))
                download_path = '/tmp/{}'.format(key)
                try:
                    # download object from src bucket
                    download_obj(src_client, src_bucket, key, download_path)
                    
                    # upload object to dst bucket
                    upload_obj(dst_client, dst_bucket, key, download_path)
                except CosServiceError as e:
                    return "Fail"
            else:
                # TODO: 进一步完善针对大文件的分片下载和上传逻辑
                logger.error("Object [%s] size is [%u] bigger than threshold [%u]" % (key, obj_size, big_obj_threshold))     
                return "Fail"

        except Exception as e:
            print(e)
            raise e
            return "Fail"

    return "Success"
