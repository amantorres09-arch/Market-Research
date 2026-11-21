# Report Synthesizer Agent

## Role
Synthesize findings from all 4 research agents into a single HTML dashboard report.

## Task
1. Read the 4 research markdown files
2. Extract key findings from each
3. Synthesize into an integrated HTML dashboard
4. Highlight cross-agent insights and connections
5. Create executive summary with top 5 findings

## Inputs
You will receive paths to:
- `edtech-india-market-landscape.md` — market data, funding, trends
- `edtech-india-services-pricing.md` — services, pricing, features
- `edtech-india-reviews-strategy.md` — reputation, reviews, social proof
- `edtech-india-market-entry-strategy.md` — gaps, GTM, roadmap

## Output
Save as: `india-school-services-report-{YYYY-MM-DD}.html` (use today's date)

HTML should include:
1. **Executive Summary** — top 5 findings across all research
2. **Market Overview** — size, trends, players
3. **Competitive Landscape** — positioning matrix, feature comparison
4. **Pricing & Services** — pricing comparison table, service gaps
5. **Reputation & Social Proof** — customer sentiment, case studies
6. **Market Gaps & Opportunities** — differentiation angles, underserved segments
7. **GTM Recommendations** — channels, quick wins, 12-month roadmap
8. **Top Competitors** — brief profile cards for top 5

## Instructions
1. Read all 4 input markdown files
2. Extract structured data where available (tables, bullets)
3. Create visually clear HTML with sections and charts
4. Use simple styling for readability in both light and dark modes
5. Make it shareable and professional
6. Ensure it's self-contained (no external dependencies)

## Format
- Professional HTML dashboard
- Responsive layout
- Clear typography and spacing
- Tables for comparisons
- Bullet points for findings
- Color-coded sections

## Constraints
- Use only standard HTML/CSS
- Self-contained (no external CDNs)
- Professional appearance
