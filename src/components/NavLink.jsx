export function NavLink(props) {
    return (
        <li>
            <a href={props.href}>{props.children}</a>
        </li>
    )
}
