import classes from './NavBar.module.css';
import {NavLink} from 'react-router-dom';

function NavBar(){
    return (
            <div className={classes.container}>
                <ul className={classes.list}>
                    <li><span className={classes.span}>WORKHORSE</span></li>
                    <li className={classes.li}><NavLink to= "/account" className={classes.link} activeClassName={classes.active}>My Account</NavLink></li>
                    <li className={classes.li}><NavLink to= "/workers" className={classes.link} activeClassName={classes.active}>Workers</NavLink></li>
                    <li className={classes.li}><NavLink to= {"/jobs-w"} className={classes.link} activeClassName={classes.active}>Jobs</NavLink></li>
                </ul>
            </div>
    );
}

export default NavBar;