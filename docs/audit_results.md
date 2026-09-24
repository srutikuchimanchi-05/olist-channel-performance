# Data Audit Results

Run on the raw layer before modeling. Purpose: check how many sellers acquired through the marketing funnel actually made sales, and decide which channels are large enough to analyze separately.

## 1. Overall activation

| Closed-deal sellers | Sellers with orders | % active |
|---|---|---|
| 842 | 380 | 45.1% |

More than half of acquired sellers never made a sale. Activation is analyzed as its own outcome.

## 2. Lead-to-close conversion by channel

| Channel | Leads | Closed deals | Conversion rate |
|---|---|---|---|
| organic_search | 2,296 | 271 | 11.8% |
| paid_search | 1,586 | 195 | 12.3% |
| social | 1,350 | 75 | 5.6% |
| unknown | 1,159 | 193 | 16.7% |
| direct_traffic | 499 | 56 | 11.2% |
| email | 493 | 15 | 3.0% |
| referral | 284 | 24 | 8.5% |
| other | 150 | 4 | 2.7% |
| display | 118 | 6 | 5.1% |
| other_publicities | 65 | 3 | 4.6% |
| **Total** | **8,000** | **842** | **10.5%** |

## 3. Activation by channel

| Channel | Closed deals | Sellers with orders | Activation rate |
|---|---|---|---|
| organic_search | 271 | 113 | 41.7% |
| paid_search | 195 | 101 | 51.8% |
| unknown | 193 | 85 | 44.0% |
| direct_traffic | 56 | 31 | 55.4% |
| social | 75 | 31 | 41.3% |
| referral | 24 | 9 | 37.5% |
| email | 15 | 6 | 40.0% |
| display | 6 | 2 | 33.3% |
| other | 4 | 2 | 50.0% |
| other_publicities | 3 | 0 | 0.0% |

## Decisions

**Channel grouping for analysis:**

| Group | Includes | Active sellers |
|---|---|---|
| organic_search | organic_search | 113 |
| paid_search | paid_search | 101 |
| unknown | unknown (includes blank origin) | 85 |
| direct_traffic | direct_traffic | 31 |
| social | social | 31 |
| other | referral, email, display, other, other_publicities | 19 |

**Rationale:**
- Channels with fewer than 10 active sellers are too small to test on their own, so they are pooled into "other." No budget recommendation is made for the pooled group.
- "Unknown" stays separate: it is the third-largest group and has the highest conversion rate, so it is reported as a data-quality finding (untracked acquisition source).
- Some sellers signed shortly before the order data ends, so part of the inactive group may be "not yet" rather than "never." Activation will be measured within a fixed window after signing.

## 4. Observation window

| Month (2018) | Orders |
|---|---|
| Jan to Aug | 6,167 to 7,269 per month |
| Sep | 16 |
| Oct | 4 |

Order volume collapses after August 2018, so the effective end of the data is **August 31, 2018**.

**Decision:** 90-day performance window. Only sellers who signed on or before June 2, 2018 are included (about 665 of 842). All outcomes (activation, revenue, reviews, delivery) are measured within each seller's first 90 days after signing, so every seller has an equal, complete window. Sellers who signed later are excluded rather than counted as inactive.

**Data cleaning note:** 551 duplicate reviews were removed (one review kept per order, the most recent).

## 5. First look at channel performance

Sellers in the analysis window (signed by June 2, 2018): 667, of whom 289 were active in their first 90 days. Revenue is in Brazilian reais (R$), 90-day window. These are descriptive results only; formal statistical tests follow in the analysis phase.

### Activation, revenue, reviews, and delivery by channel

| Channel | Sellers | Active (90d) | Activation rate | Mean revenue (active) | Avg review | Late delivery rate |
|---|---|---|---|---|---|---|
| organic_search | 208 | 81 | 38.9% | 1,095.28 | 4.39 | 3.9% |
| unknown | 165 | 67 | 40.6% | 1,909.40 | 4.33 | 7.3% |
| paid_search | 146 | 80 | 54.8% | 934.52 | 4.32 | 5.1% |
| social | 55 | 24 | 43.6% | 496.33 | 4.29 | 3.8% |
| direct_traffic | 49 | 22 | 44.9% | 407.76 | 4.29 | 4.4% |
| other | 44 | 15 | 34.1% | 1,538.51 | 4.25 | 1.8% |

### Revenue distribution among active sellers

| Channel | Active sellers | Median revenue | Mean revenue | Max revenue |
|---|---|---|---|---|
| other | 15 | 394.40 | 1,538.51 | 6,224.00 |
| organic_search | 81 | 390.00 | 1,095.28 | 28,265.80 |
| paid_search | 80 | 327.14 | 934.52 | 15,424.85 |
| unknown | 67 | 299.98 | 1,909.40 | 74,434.44 |
| direct_traffic | 22 | 224.21 | 407.76 | 1,343.10 |
| social | 24 | 214.94 | 496.33 | 2,854.55 |

### Observations

- **Means are skewed by a few large sellers.** Mean revenue is 2 to 6 times the median in every channel. A single seller accounts for about 58% of the "unknown" channel's 90-day revenue, which alone makes that channel look like the top earner by mean.
- **By median, revenue among active sellers looks similar across the main channels** (organic R$390, paid R$327, unknown R$300). This will be tested formally with Kruskal-Wallis.
- **Activation differs most.** Paid search sellers activated at 54.8% versus 38.9% for organic search, the largest gap between the two biggest channels.
- **Review scores (4.25 to 4.39) and late delivery rates (2% to 7%) vary little by channel.**

**Implications for the analysis:** use median-based and rank-based tests for revenue (Kruskal-Wallis, bootstrap confidence intervals on medians), log-transform revenue in the regression, and rerun key results without the top 1% of sellers as a sensitivity check.