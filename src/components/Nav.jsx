import { useState } from 'react';
import { Divider, NavLink } from './';
import { useMediaQuery } from 'react-responsive';

export function Nav() {
    const [expanded, setExpanded] = useState(false);
    const handleClick = () => {
        setExpanded(!expanded);
    };
    const isBigScreen = useMediaQuery({ query: '(min-device-width: 1080px)' });
    return (
        <div id="nav">
            {isBigScreen ? (
                <div>
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
                        <div>
                            <i class="fas fa-bars"></i>
                        </div>
                    </span>
                </div>
            ) : (
                <div className="responsive">
                    {expanded ? (
                        <div>
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
                        </div>
                    ) : (
                        ''
                    )}
                    <span class="toggle">
                        <div>
                            <button onClick={handleClick}>
                                <i class="fas fa-bars"></i>
                            </button>
                        </div>
                    </span>
                </div>
            )}
        </div>
    );
}
