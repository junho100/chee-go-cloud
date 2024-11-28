# 취Go Cloud

대학생 대상 교육 및 편의 기능 지원 서비스 [취Go] Cloud 레포지토리

---

## 아키텍처 개요

![arch drawio](https://github.com/user-attachments/assets/bf7c20b5-15ac-46bc-bd3d-703c54b6ef88)

이 인프라는 다음과 같은 주요 컴포넌트들로 구성되어 있습니다:

### 네트워크 계층

- VPC (10.1.0.0/16)
- 2개의 가용영역 (ap-northeast-2a, ap-northeast-2c)
- 퍼블릭 서브넷 2개
- 프라이빗 서브넷 2개
- 데이터베이스 서브넷 2개
- NAT 인스턴스 (Bastion Host)

### 애플리케이션 계층

- Application Load Balancer
- EC2 인스턴스 (백엔드 서버)
- CloudFront 배포 (프론트엔드)
- S3 버킷 (정적 웹 호스팅)
- CodeDeploy 애플리케이션
- ECR 레포지토리

### 데이터 계층

- RDS MySQL 8.0 인스턴스
- ElastiCache Redis 7.1 클러스터

### 보안

- 각 계층별 보안그룹
- IAM 역할 및 정책
- ACM 인증서 (us-east-1, ap-northeast-2)

### DNS & CDN

- Route 53 호스팅 영역
- CloudFront 배포
- ACM 인증서

## 주요 기능

### CI/CD

- CodeDeploy를 통한 백엔드 배포 자동화
- CloudFront를 통한 프론트엔드 정적 컨텐츠 배포
- ECR을 통한 도커 이미지 관리

### 모니터링

- CloudWatch 에이전트 설치
- 메모리 사용량 모니터링
- 인스턴스 상태 체크

### 보안

- 프라이빗 서브넷의 워크로드 보호
- Bastion Host를 통한 접근 제어
- NAT Instance를 통한 내부 IP 은닉
- HTTPS 적용 (ACM 인증서)
- 보안그룹을 통한 네트워크 접근 제어

## 사전 요구사항

- Terraform 설치
- AWS CLI 설치 및 구성
- AWS 계정 및 액세스 키
- Route 53에 등록된 도메인

## 환경 변수

다음 변수들이 필요합니다:

- aws_access_key: AWS 액세스 키
- aws_secret_key: AWS 시크릿 키
- environment: 환경 (dev, stage, prod)
- project_name: 프로젝트 이름
- db_password: RDS 데이터베이스 비밀번호
- db_username: RDS 데이터베이스 사용자 이름
- db_name: RDS 데이터베이스 이름
- domain_name: 도메인 이름

## 사용 방법

1. 환경 변수 설정:

```bash
export TF_VAR_aws_access_key="your-access-key"
export TF_VAR_aws_secret_key="your-secret-key"
```

2. Terraform 초기화:

```bash
terraform init
```

3. 실행 계획 확인:

```bash
terraform plan
```

4. 인프라 배포:

```bash
terraform apply
```

5. 인프라 삭제:

```bash
terraform destroy
```

## 주의사항

- 프로덕션 환경에 배포하기 전에 보안 설정을 검토하세요
- 민감한 정보는 반드시 환경 변수나 AWS Secrets Manager를 통해 관리하세요
- 비용 발생을 방지하기 위해 사용하지 않는 리소스는 삭제하세요

## 디렉토리 구조

```
.
├── README.md
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── network.tf
├── ec2-instance.tf
├── rds.tf
├── elasticache.tf
├── security-group.tf
├── alb.tf
├── cloudfront.tf
├── route53.tf
├── acm.tf
├── iam.tf
├── s3.tf
├── code-deploy.tf
├── ecr.tf
├── modules/
│   └── naming/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
└── files/
    ├── user-data.sh
    ├── backend-policy.tftpl
    ├── backend-bucket-policy.tftpl
    ├── codedeploy-policy.tftpl
    ├── static-web-bucket-policy.tftpl
    └── web-cicd-policy.json
```
