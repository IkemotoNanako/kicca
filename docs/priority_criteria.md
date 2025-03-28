# 優先順位基準の定義

## 概要
アプリケーション内で表示される情報の優先順位を決定する基準を定義します。
この基準は、ユーザーにとって最も重要な情報を最適なタイミングで提供するために使用されます。

## 優先順位の種類

### 1. 支援情報の優先順位基準
支援情報は、ユーザーの生活や仕事における困りごとに対する具体的な支援策を提供します。

#### スコアリング基準
- 緊急度（60%）
  - 高（3点）：即時的な対応が必要
  - 中（2点）：数日以内の対応が必要
  - 低（1点）：長期的な対応で問題ない

- 重要度（40%）
  - 高（3点）：生活や仕事に重大な影響がある
  - 中（2点）：一定の影響がある
  - 低（1点）：軽微な影響

#### 優先順位の判定
- 高優先（6点）
  - 緊急度と重要度が両方とも高い
  - 即時的な対応が必要で、かつ重大な影響がある

- 中優先（4-5点）
  - 緊急度または重要度のいずれかが高い
  - 即時的な対応が必要か、重大な影響がある

- 低優先（1-3点）
  - それ以外のケース
  - 長期的な対応で問題なく、影響も軽微

### 2. ツール・サービスの優先順位基準
ツール・サービスは、ユーザーの生活や仕事をサポートする具体的な手段を提供します。

#### スコアリング基準
- 実装の容易さ（40%）
  - 高（3点）：即時的に導入可能
  - 中（2点）：数日程度で導入可能
  - 低（1点）：導入に時間がかかる

- 効果の高さ（60%）
  - 高（3点）：大きな改善効果が期待できる
  - 中（2点）：一定の改善効果が期待できる
  - 低（1点）：軽微な改善効果

#### 優先順位の判定
- 高優先（6点）
  - 実装が容易で効果が高い
  - 即時的に導入可能で、大きな改善効果が期待できる

- 中優先（4-5点）
  - 実装の容易さまたは効果の高さのいずれかが高い
  - 即時的な導入が可能か、大きな改善効果が期待できる

- 低優先（1-3点）
  - それ以外のケース
  - 導入に時間がかかるか、軽微な改善効果

### 3. 生活の知恵の優先順位基準
生活の知恵は、ユーザーの日常生活をより良くするための具体的なアドバイスを提供します。

#### スコアリング基準
- 即時性（50%）
  - 高（3点）：即時的に実践可能
  - 中（2点）：準備が必要
  - 低（1点）：長期的な実践が必要

- 実用性（50%）
  - 高（3点）：即座に効果を実感できる
  - 中（2点）：一定期間の実践で効果を実感できる
  - 低（1点）：長期的な実践が必要

#### 優先順位の判定
- 高優先（6点）
  - 即時性と実用性が両方とも高い
  - 即時的に実践可能で、即座に効果を実感できる

- 中優先（4-5点）
  - 即時性または実用性のいずれかが高い
  - 即時的に実践可能か、即座に効果を実感できる

- 低優先（1-3点）
  - それ以外のケース
  - 長期的な実践が必要か、効果を実感するのに時間がかかる

## 実装の注意点
1. スコアリングは0-100のスケールに正規化する
2. 優先順位は定期的に更新する（1日1回）
3. ユーザーのフィードバックに基づいて基準を調整する 