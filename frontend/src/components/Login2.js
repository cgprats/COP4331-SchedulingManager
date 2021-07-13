import classes from './Login2.module.css';
import workerLogo from '../icons/Workers.png';
import {useRef} from 'react';

function Login2(props)
{
    const emailRef = useRef();
    const passRef = useRef();
    
    function loginHandler(event)
    {
        event.preventDefault();
        const email = emailRef.current.value;
        const password = passRef.current.value;

        const signinData = 
        {
            email: email,
            password: password
        }
    }

    return (
        <div className={classes.logcard}>
            <div className={classes.col}>
                <h2 className={classes.h2}>SIGN IN</h2>
                <form>
                    <div>
                        <label className={classes.label}>Email</label> <br></br>
                        <input type='text' className={classes.input} required id='email'/>
                    </div>
                    <div>
                        <label className={classes.label}>Password</label> <br></br>
                        <input type='text' className={classes.input} required id='password'/>
                    </div>
                    <div>
                        <button className={classes.myButton} onClick={loginHandler}>SIGN IN</button>
                    </div>
                </form>
                <span className={classes.span}>Don't have an account?</span>
                <button className={classes.link} onClick={props.onClick}> Sign up!</button>
            </div>
            <div className={classes.right}>
                    <img src={workerLogo} className={classes.image2}/>
                    <h3 className={classes.second}>WORKER</h3>
            </div>
            
            
        </div>
    );
}

export default Login2;