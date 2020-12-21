import { Divider } from './';

export function Nav() {
    return (
        <div id="nav">
            <ul>
                <li>
                    <a href="/">Home</a>
                </li>
                <Divider />
                <li>
                    <a href="/deploy">Deploy New Caring Wallet</a>
                </li>
                <Divider />
                <li>
                    <a href="/configure">Configure Caring Wallet</a>
                </li>
                <Divider />
                <li>
                    <a href="/source">Source Code</a>
                </li>
            </ul>
        </div>
    );
}
