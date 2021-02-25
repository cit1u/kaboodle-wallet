import { Divider, NavLink } from './';

export function Nav() {
    return (
        <div id="nav">
            <ul>
                <NavLink href="/">Home</NavLink>
                <Divider />
                <NavLink href="/deploy">Deploy New Caring Wallet</NavLink>
                <Divider />
                <NavLink href="/configure">Configure Caring Wallet</NavLink>
                <Divider />
                <NavLink href="/source">Source Code</NavLink>
                <NavLink href="/connect" id="connect-wallet">Connect Wallet</NavLink>
            </ul>
        </div>
    );
}
