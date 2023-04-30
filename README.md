# docker-wireguard-pia-transmission
Docker container which connects to PrivateInternetAccess VPN, using WireGuard, downloading torrents with Transmission

I always used VirtualBox as my SeedBox but after playing with Docker and the two of them not working well together, I converted my seedbox to a Docker container.

Basically you start the container and your torrents get downloaded and seeded, withouyt any hassels.
I only have one problem, but will get to that in a while.

<B>What you need:</B>
<li>Working docker setup
<li>PIA account ( I haven't tried any others)
<p>
I have made the container to accept an SSH tunnel connection which tunnels my https connection , because I have a myanonamouse account, and they check that the seedbox and the ip connecting to their site is the same.

Get the files and then change your own username and passwords and try it out.
