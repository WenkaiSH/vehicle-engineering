#!/bin/bash
# 车辆工程知识库 GitHub 自动同步脚本
# 执行时间：每周一/三/五/日 02:00

set -e

REPO_DIR="/root/.openclaw/workspace/车辆工程知识"
LOG_FILE="/root/.openclaw/workspace/backups/vehicle-engineering-sync.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# 日志函数
log() {
    echo "[$DATE] $1" | tee -a "$LOG_FILE"
}

cd "$REPO_DIR"

# 检查是否有变更
if git diff --quiet && git diff --cached --quiet; then
    log "INFO: 没有变更需要同步"
    exit 0
fi

# 添加所有变更
git add -A

# 提交变更
COMMIT_MSG="auto-sync: $DATE

- 自动同步车辆工程知识库变更
- 同步周期：周一/三/五/日 02:00"

git commit -m "$COMMIT_MSG" || {
    log "INFO: 没有需要提交的变更"
    exit 0
}

# 推送到 GitHub
git push origin main && {
    log "SUCCESS: 同步完成"
} || {
    log "ERROR: 推送失败"
    exit 1
}
