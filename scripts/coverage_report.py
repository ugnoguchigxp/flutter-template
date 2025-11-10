#!/usr/bin/env python3
"""
カバレッジレポート生成スクリプト

使い方:
  python3 scripts/coverage_report.py

前提:
  flutter test --coverage を実行済みであること
"""

import re
import sys
from pathlib import Path


def parse_lcov_file(lcov_path):
    """lcovファイルを解析してカバレッジデータを返す"""
    if not lcov_path.exists():
        print(f"エラー: {lcov_path} が見つかりません")
        print("先に 'flutter test --coverage' を実行してください")
        sys.exit(1)

    with open(lcov_path, 'r') as f:
        content = f.read()

    records = content.split('end_of_record')
    coverage_data = []

    for record in records:
        if not record.strip():
            continue

        sf_match = re.search(r'SF:(.+)', record)
        lf_match = re.search(r'LF:(\d+)', record)
        lh_match = re.search(r'LH:(\d+)', record)

        if sf_match and lf_match and lh_match:
            filepath = sf_match.group(1)
            lines_found = int(lf_match.group(1))
            lines_hit = int(lh_match.group(1))
            coverage = (lines_hit / lines_found * 100) if lines_found > 0 else 0

            coverage_data.append({
                'file': filepath,
                'lf': lines_found,
                'lh': lines_hit,
                'coverage': coverage
            })

    return coverage_data


def categorize_files(coverage_data):
    """ファイルをカテゴリ別に分類"""
    categories = {
        'core': [],
        'features': [],
        'generated': []
    }

    for data in coverage_data:
        filepath = data['file']

        if '.freezed.dart' in filepath or '.g.dart' in filepath:
            categories['generated'].append(data)
        elif '/core/' in filepath:
            categories['core'].append(data)
        elif '/features/' in filepath:
            categories['features'].append(data)

    return categories


def print_summary(coverage_data):
    """サマリー情報を表示"""
    if not coverage_data:
        print("カバレッジデータがありません")
        return

    total_lf = sum(d['lf'] for d in coverage_data)
    total_lh = sum(d['lh'] for d in coverage_data)
    overall_coverage = (total_lh / total_lf * 100) if total_lf > 0 else 0

    print("=" * 80)
    print("📊 カバレッジサマリー")
    print("=" * 80)
    print(f"\n✅ 全体カバレッジ: {overall_coverage:.1f}% ({total_lh}/{total_lf} lines)")
    print(f"📄 テストファイル数: {len(coverage_data)}")
    print()


def print_category_report(title, data):
    """カテゴリ別のレポートを表示"""
    if not data:
        return

    total_lf = sum(d['lf'] for d in data)
    total_lh = sum(d['lh'] for d in data)
    category_coverage = (total_lh / total_lf * 100) if total_lf > 0 else 0

    print(f"\n{title}")
    print("─" * 80)
    print(f"カテゴリカバレッジ: {category_coverage:.1f}% ({total_lh}/{total_lf} lines)")
    print()

    # カバレッジ率でソート
    sorted_data = sorted(data, key=lambda x: x['coverage'])

    # 低カバレッジファイル
    low_coverage = [d for d in sorted_data if d['coverage'] < 80]
    if low_coverage:
        print("⚠️  低カバレッジファイル (80%未満):")
        for d in low_coverage:
            filename = d['file'].split('/')[-1]
            print(f"  {d['coverage']:5.1f}% | {d['lh']:3d}/{d['lf']:3d} | {filename}")

    # 高カバレッジファイル
    high_coverage = [d for d in sorted_data if d['coverage'] >= 80]
    if high_coverage:
        print("\n✅ 高カバレッジファイル (80%以上):")
        for d in high_coverage:
            filename = d['file'].split('/')[-1]
            icon = "✨" if d['coverage'] == 100 else "✅"
            print(f"  {icon} {d['coverage']:5.1f}% | {d['lh']:3d}/{d['lf']:3d} | {filename}")


def print_improvement_suggestions(coverage_data):
    """改善提案を表示"""
    low_coverage = sorted(
        [d for d in coverage_data if d['coverage'] < 80],
        key=lambda x: x['lf'] - x['lh'],
        reverse=True
    )

    if not low_coverage:
        print("\n🎉 すべてのファイルが80%以上のカバレッジを達成しています！")
        return

    print("\n" + "=" * 80)
    print("💡 改善優先順位（未カバー行数順）")
    print("=" * 80)

    for i, d in enumerate(low_coverage[:5], 1):
        filename = d['file'].split('/')[-1]
        uncovered = d['lf'] - d['lh']
        print(f"\n{i}. {filename}")
        print(f"   現在: {d['coverage']:.1f}% ({d['lh']}/{d['lf']})")
        print(f"   未カバー: {uncovered} 行")
        print(f"   目標80%達成には: {int(d['lf'] * 0.8) - d['lh']} 行のテスト追加が必要")


def main():
    """メイン処理"""
    # プロジェクトルートディレクトリを取得
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    lcov_path = project_root / 'coverage' / 'lcov.info'

    print("\n🔍 カバレッジファイルを解析中...")
    coverage_data = parse_lcov_file(lcov_path)

    print_summary(coverage_data)

    # カテゴリ別にレポート
    categories = categorize_files(coverage_data)

    # 生成コードを除外した実質的なカバレッジ
    non_generated = categories['core'] + categories['features']

    if non_generated:
        total_lf = sum(d['lf'] for d in non_generated)
        total_lh = sum(d['lh'] for d in non_generated)
        actual_coverage = (total_lh / total_lf * 100) if total_lf > 0 else 0
        print(f"📌 実質カバレッジ（生成コード除外）: {actual_coverage:.1f}%\n")

    print_category_report("🔧 Core層", categories['core'])
    print_category_report("🎮 Features層", categories['features'])

    if categories['generated']:
        print(f"\n🤖 生成コード: {len(categories['generated'])}ファイル (テスト不要)")

    print_improvement_suggestions(coverage_data)

    print("\n" + "=" * 80)
    print("詳細なHTMLレポートを生成するには:")
    print("  genhtml coverage/lcov.info -o coverage/html")
    print("  open coverage/html/index.html")
    print("=" * 80)
    print()


if __name__ == '__main__':
    main()
