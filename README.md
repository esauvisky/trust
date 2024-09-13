# TRUST: TRUST Reveals Undisclosed Speed Throttling

Welcome to **TRUST**, where we put your ISP's promises to the ultimate test. Because in the world of internet speeds, trust but verify, right?

## What's Inside This Can of Worms?

- **selected_servers.csv**: Your hit list of servers. These aren't just any servers; they're the chosen ones, picked for their honesty... or at least, we hope.

- **select_random_servers.sh**: This script is like a lottery for servers, except everyone wins because we're all about fairness here. It shuffles, picks, and checks if these servers are telling the truth about being up to the job.

  ```bash
  # Example usage:
  # Run this to shuffle the deck and deal out the honest servers
  ./select_random_servers.sh
  ```

- **server_check_log.txt**: Here lies the tale of which servers stood tall and which crumbled under the weight of our expectations.

- **speedtest.sh**: This is where the magic happens. Or the disappointment. Depends on your ISP. This script goes out, shakes hands with each server, and asks, "How fast can you really go?"

  ```bash
  # Example usage:
  # To see if your ISP's pants are on fire
  ./speedtest.sh
  ```

## How to Use TRUST Without Trusting Too Much

1. **Setup**: Make sure you've got `speedtest-cli` installed because we're not here to play; we're here to measure.

2. **Run the Server Lottery**: Execute `select_random_servers.sh` to get your list of potentially honest servers. Remember, in the world of ISPs, 'potentially' is as good as it gets.

3. **The Moment of Truth**: Run `speedtest.sh`. Watch as TRUST does its thing, revealing if your internet speed is as advertised or if it's just another fairy tale.

4. **Analyze**: Check out `speedtest_results.csv` for the cold, hard numbers. Will your ISP be a hero or a zero?

## Why TRUST?

Because in an age where "up to" might mean "nowhere near," TRUST ensures you're not just another sucker in the grand ISP circus. Here, we don't just trust; we test, we verify, and occasionally, we cry over our download speeds.

## Disclaimer

Using TRUST might lead to:

- **Disillusionment**: Realizing your 1Gbps is more like 1Mbps on a good day.
- **Anger**: At your ISP, at the universe, at the slow loading bar...
- **Acceptance**: That no matter what you pay, your ISP's "best effort" might just be a lazy shrug.

So, dive into TRUST, where we're all about that bandwidth, 'bout that bandwidth, no treble.