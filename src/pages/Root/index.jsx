import { Box } from '../../components/';

export function Root() {
    import('./style.css');

    return (
        <div id="root-container">
            <div className="container">
            <Box title="Project Sharing"><p className="text-center">Sharing is caring</p></Box>
            <Box><div className="wallet"><p>Seems like you don't have a wallet connected</p><p><a href="/connect" className="connect">Connect Wallet</a></p></div></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            <Box><p>box without title</p></Box>
            </div>
        </div>
    );
}
