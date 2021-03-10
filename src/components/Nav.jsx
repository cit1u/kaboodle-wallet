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
                <NavLink href="/">Connect Wallet</NavLink>
            </ul>
            <span class="toggle">
                <i class="fas fa-bars"></i>
            </span>
        </div>
    );
}
