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