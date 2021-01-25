import { Box } from '../../components/';

export function Root() {
    import('./style.css');

    return (
        <div id="root-container">
            <Box><p>box without title</p></Box>
            <Box title="title"><p>box with title</p></Box>
        </div>
    );
}
