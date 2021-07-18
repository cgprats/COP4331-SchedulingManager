import classes from './NavBar.module.css';
import {NavLink} from 'react-router-dom';

function NavBar(props){
    return (
        <div>
            <ul className={classes.list}>
                <li><span className={classes.span}>WORKHORSE</span></li>
                <li className={classes.li}><NavLink to= "/account-info" className={classes.link} activeClassName={classes.active}>My Account</NavLink></li>
                <li className={classes.li}><NavLink to= "/staff" className={classes.link} activeClassName={classes.active}>Workers</NavLink></li>
                <li className={classes.li}><NavLink to= {`/jobs-${props.end}`} className={classes.link} activeClassName={classes.active}>Jobs</NavLink></li>
            </ul>
        </div>
    );
}

export default NavBar;