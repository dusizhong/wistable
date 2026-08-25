#!/usr/bin/env bash
# WisTable 小组件编译部署脚本
# 用法: source scripts/dev-env.sh && bash frontend/widgets/build-and-deploy.sh
set -e

# 连接端点：开发环境默认本机（127.0.0.1），生产容器内通过 environment 覆盖为 minio / mysql 服务名
S3_ENDPOINT="${S3_ENDPOINT:-http://127.0.0.1:9000}"
MYSQL_HOST="${MYSQL_HOST:-127.0.0.1}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# packageId|entry|dbReleaseId|projectDir
# entry="" 表示模版小组件，只上传配图不编译
declare -A WIDGETS
WIDGETS[widget-chart]="wpkCKtqGTjzM7|src/index.ts|1732343795235733505"
WIDGETS[widget-summary]="wpkY6DKgb3iVk|src/index.ts|1730256188603416577"
WIDGETS[widget-pivot-table]="wpkgMavSIOOR9|src/index.tsx|1730256181150138370"
WIDGETS[widget-funnel-chart]="wpkZV0RkAD90t|src/index.tsx|1650513300351299586"
WIDGETS[widget-script]="wpkPUIDr5rxh9|src/index.tsx|1655816935005073409"
WIDGETS[widget-airtable-import]="wpk098vuAfpQa|src/index.tsx|1735180270532870146"
WIDGETS[widget-hello-world-typescript]="wpk2jJ7qZS0VG||1635541524491706370"
WIDGETS[widget-hello-world-javascript]="wpkyVrnMm6ymP||1631121898993664002"
WIDGETS[widget-developer-template]="wpkSybhcxsmGM||1631134343993688065"
WIDGETS[widget-todo-list-template]="wpkP54M0LMh9U||1631132517940527106"

CLI_LIB="$(npm root -g)/@apitable/widget-cli/lib/utils/project"
DATE_PATH="space/$(date +%Y/%m/%d)"

# --- Upload shared author_icon (all widgets use the same) ---
AUTHOR_ICON_SRC="${SCRIPT_DIR}/widget-chart/author_icon.png"
AUTHOR_ICON_TARGET="widget/_shared/author_icon.png"
echo "=== Uploading shared author_icon ==="
python3 -c "
import boto3
from botocore.config import Config
s3 = boto3.client('s3',
    endpoint_url='${S3_ENDPOINT}',
    aws_access_key_id='${MINIO_ACCESS_KEY}',
    aws_secret_access_key='${MINIO_SECRET_KEY}',
    config=Config(signature_version='s3v4'), region_name='us-east-1')
try: s3.create_bucket(Bucket='assets')
except: pass
# Set public read policy so uploaded files are accessible via /assets/ proxy
s3.put_bucket_policy(Bucket='assets', Policy='{\"Version\":\"2012-10-17\",\"Statement\":[{\"Effect\":\"Allow\",\"Principal\":{\"AWS\":[\"*\"]},\"Action\":[\"s3:GetObject\"],\"Resource\":[\"arn:aws:s3:::assets/*\"]}]}')
s3.upload_file('${AUTHOR_ICON_SRC}', 'assets', '${AUTHOR_ICON_TARGET}', ExtraArgs={'ContentType': 'image/png'})
print('  uploaded to ${AUTHOR_ICON_TARGET}')
"

echo ""
echo "=== Building all widgets ==="
for dir in "${!WIDGETS[@]}"; do
  info="${WIDGETS[$dir]}"
  pkgId="${info%%|*}" ; rest="${info#*|}"
  entry="${rest%%|*}" ; releaseId="${rest#*|}"

  echo ""
  echo "--- $dir ($pkgId) ---"
  cd "$SCRIPT_DIR/$dir"

  # Determine icon file: package_icon.png or logo.png
  if [ -f "package_icon.png" ]; then
    ICON_SRC="package_icon.png"
  elif [ -f "logo.png" ]; then
    ICON_SRC="logo.png"
  else
    echo "  WARNING: no icon file found"
    ICON_SRC=""
  fi

  # Compile widget if source entry is specified
  if [ -n "$entry" ]; then
    if [ ! -d "node_modules" ]; then
      echo "  Installing deps..."
      npm install --legacy-peer-deps --registry=https://registry.npmmirror.com >/dev/null 2>&1
    fi

    echo "  Building..."
    echo "{\"packageId\":\"$pkgId\",\"entry\":\"$entry\"}" > widget.config.json
    node -e "
      const { startCompile } = require('$CLI_LIB');
      startCompile('prod', false, { assetsPublic: '', entry: '${entry}' }, () => process.exit(0));
    "

    hash=$(head -c 16 /dev/urandom | md5sum | cut -d' ' -f1)
    remotePath="${DATE_PATH}/${hash}"

    echo "  Uploading bundle to MinIO: $remotePath"
    python3 -c "
import boto3
from botocore.config import Config
s3 = boto3.client('s3',
    endpoint_url='${S3_ENDPOINT}',
    aws_access_key_id='${MINIO_ACCESS_KEY}',
    aws_secret_access_key='${MINIO_SECRET_KEY}',
    config=Config(signature_version='s3v4'), region_name='us-east-1')
s3.upload_file('dist/packed/widget_bundle.min.js', 'assets', '${remotePath}',
    ExtraArgs={'ContentType': 'application/javascript'})
print('  uploaded')
"

    echo "  Updating release $releaseId → $remotePath"
    mysql -h${MYSQL_HOST} -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" \
      -e "UPDATE apitable_widget_package_release SET release_code_bundle = '${remotePath}' WHERE id = ${releaseId};" 2>/dev/null
  else
    echo "  Template widget — skipping JS compilation"
  fi

  # --- Upload widget images to MinIO ---
  ICON_TARGET="widget/${pkgId}/icon.png"
  COVER_TARGET="widget/${pkgId}/cover.png"

  echo "  Uploading images to MinIO..."
  if [ -n "$ICON_SRC" ] && [ -f "$ICON_SRC" ]; then
    python3 -c "
from botocore.config import Config
s3 = __import__('boto3').client('s3',
    endpoint_url='${S3_ENDPOINT}',
    aws_access_key_id='${MINIO_ACCESS_KEY}',
    aws_secret_access_key='${MINIO_SECRET_KEY}',
    config=Config(signature_version='s3v4'), region_name='us-east-1')
s3.upload_file('${ICON_SRC}', 'assets', '${ICON_TARGET}', ExtraArgs={'ContentType': 'image/png'})
print('    icon → ${ICON_TARGET}')
"
  fi
  if [ -f "cover.png" ]; then
    python3 -c "
from botocore.config import Config
s3 = __import__('boto3').client('s3',
    endpoint_url='${S3_ENDPOINT}',
    aws_access_key_id='${MINIO_ACCESS_KEY}',
    aws_secret_access_key='${MINIO_SECRET_KEY}',
    config=Config(signature_version='s3v4'), region_name='us-east-1')
s3.upload_file('cover.png', 'assets', '${COVER_TARGET}', ExtraArgs={'ContentType': 'image/png'})
print('    cover → ${COVER_TARGET}')
"
  fi

  # --- Update DB package image tokens ---
  echo "  Updating DB package image tokens..."
  mysql -h${MYSQL_HOST} -uroot -p"${MYSQL_ROOT_PASSWORD}" "${MYSQL_DATABASE}" \
    -e "UPDATE apitable_widget_package
        SET icon = '${ICON_TARGET}',
            cover = '${COVER_TARGET}',
            author_icon = '${AUTHOR_ICON_TARGET}'
        WHERE package_id = '${pkgId}';" 2>/dev/null

  echo "  Done."
done

echo ""
echo "=== All widgets deployed ==="
echo "Restart backend-server to apply."
