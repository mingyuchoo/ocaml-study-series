#!/bin/bash

echo "=== 주소록 웹 서비스 테스트 ==="
echo ""

# 서버가 실행 중인지 확인
echo "1. 서버 상태 확인..."
curl -s http://localhost:8080/ > /dev/null
if [ $? -eq 0 ]; then
    echo "✓ 서버가 정상적으로 실행 중입니다."
else
    echo "✗ 서버에 연결할 수 없습니다."
    exit 1
fi

echo ""
echo "2. 주소록 목록 페이지 접근..."
curl -s http://localhost:8080/addresses | grep -q "주소록"
if [ $? -eq 0 ]; then
    echo "✓ 주소록 목록 페이지가 정상적으로 로드되었습니다."
else
    echo "✗ 주소록 목록 페이지 로드 실패"
fi

echo ""
echo "3. 새 주소 추가 폼 페이지 접근..."
curl -s http://localhost:8080/addresses/new | grep -q "새 주소 추가"
if [ $? -eq 0 ]; then
    echo "✓ 새 주소 추가 폼이 정상적으로 로드되었습니다."
else
    echo "✗ 새 주소 추가 폼 로드 실패"
fi

echo ""
echo "=== 테스트 완료 ==="
echo ""
echo "브라우저에서 http://localhost:8080/addresses 를 열어 전체 기능을 테스트하세요."
