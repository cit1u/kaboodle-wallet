import { Link } from 'react-router-dom'

export function NavLink(props) {
    if (props.id) {
        return (
            <li id={props.id}>
                <Link to={props.href}>{props.children}</Link>
            </li>
        )
    }

    return (
        <li>
            <Link to={props.href}>{props.children}</Link>
        </li>
    )
}
