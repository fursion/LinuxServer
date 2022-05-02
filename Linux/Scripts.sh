# !bin/bash
echo "$0"
echo "请选择操作项"
echo "1 :    " \
     "2 :    " \
     "Q :退出"
while :; do
     read item
     case $item in
     1)
          echo "input ${item}"
          break
          ;;
     2)
          echo "input ${item}"
          break
          ;;
     3)
          echo "input ${item}"
          break
          ;;
     4)
          echo "input ${item}"
          break
          ;;
     Q) exit 1 ;;
     *) echo "无效输入！请重新输入！" ;;
     esac
done
