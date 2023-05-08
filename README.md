# docker-wireguard-pia-transmission
Docker container which connects to PrivateInternetAccess VPN, using WireGuard, downloading torrents with Transmission, using port forwarding.

I always used VirtualBox as my SeedBox but after playing with Docker and the two of them not working well together, I converted my seedbox to a Docker container.

Basically you start the container and your torrents get downloaded and seeded, without any hassels.
I only have one problem, but will get to that in a while.

<B>What you need:</B>
<li>Working docker setup
<li>PIA account ( I haven't tried any others)
<li><a href="https://github.com/pia-foss/manual-connections">Get the original PIA scripts from here</a>
<li><a href="https://github.com/silvinux/transmission-alpine">I used one script from here</a>
<p>
I have made the container to accept an SSH tunnel connection which tunnels my https connection , because I have a myanonamouse account, and they check that the seedbox and the ip connecting to their site is the same.

Get the files and then change your own username and passwords and try it out.
<p>
<p>cd into the new created folder, mkdir tmp, cd to tmp and run:
<code>git clone https://github.com/pia-foss/manual-connections.git</code>
<p>Copy everything from the manual-connections folder to the one in your scr folder apart from the one file already there (port_forwarding.sh)
<p> delete the tmp folder when your done.
<p>
<p>Now run <code>docker compose build --no-cache --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)"</code>
<p>And then <code>docker compose up</code>

<B>To forward the vpn to your local pc</B>
<p>Type <code>ssh -D 1337 -C -N root@localhost -p 33</code> in a new terrminal, to activate the ssh tunnel.
<i>Then I use an addon in Firefox called Multi-Account containers where I set up a Proxy, title VPN, Protocol Socks5, Server 127.0.0.1 Port 1337, select Do not proxy local addresses and select Proxy DNS requests, to use the same VPN to connect to the site I want to.</i>
<p>
Hope it helps.

