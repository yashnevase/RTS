# First workshop implementation plan

Start with one grain mill at Pune. This is a gameplay production model with tunable quantities, rather than a claim about a particular historic business.

## Stock and money

The mill owns cash, grain input, flour output, recipe progress and a ledger. Acquisition transfers the purchase price from the clan. Working capital is a separate transfer. Deposits and withdrawals move existing goods and money. Production consumes grain and time, creates flour, and deducts wages only for completed work.

Input purchases use the existing local market and its live stock. A player-controlled maximum input price prevents buying at any cost. Storage limits stop production when full. Output can remain in storage, be withdrawn, or be sold to the local market at an explicit minimum price. Revenue is recorded only when a sale actually transfers goods and coin. Spoilage and more recipes follow after this chain is verified.

## Controls and feedback

Settlement actions open the workshop. Show an illustration and recipe on the left, input/output stores in the middle, cash and ledger on the right. Controls include buy inputs automatically, input price limit, sell output automatically, output price floor, deposit/withdraw, pause, and transfer working capital. Quantities use the same portrait/icon rows and plus/minus sliders as trade and recruitment.

Always display a status with a concrete cause. Examples include producing, paused by owner, waiting for grain, input too expensive, insufficient wages, output storage full, and no buyer within the price limit. Show last 7 days' input costs, wages, sales and realized net cash. Stock on hand is not income.

## Checks before expanding

Verify save/load, deterministic replay, conservation of money and transfers, no production without inputs, bounded storage, no free payout for unsold output and atomic cancellation. Run a year with low, normal and interrupted supplies. Competition should lower output prices through shared market stock, while blocked deliveries reduce available inputs.

## References reviewed

The supplied [workshop discussion](https://www.reddit.com/r/Bannerlord/comments/148ybjc/comment/jo2yrpt/) describes supply, prosperity, competition, trade and interrupted deliveries. The [second thread](https://www.reddit.com/r/Bannerlord/comments/14e5dmd/how_do_the_workshops_work/) includes an example of a workshop not producing and reinforces the need to explain stalled operations. Both are community posts from 2023. Exact values and current Bannerlord behavior were not verified.

The supplied videos are titled [Workshops Explained (Quickly)](https://youtu.be/sfoDPJYpeo4) and [MONEY GUIDE Workshops](https://youtu.be/5GbYBvx-hXc). Metadata was accessible, but playback and transcripts were unavailable. Their mechanics were not used as verified implementation rules.
