import classes from './ForgotPassword.module.css';
import {useRef} from 'react';
import {useState} from 'react';
import {Link} from 'react-router-dom';

function ForgotPassword(props)
{
    const verRef = useRef();
    const emailRef = useRef();
    const passRef = useRef();
    const confRef = useRef();


    const [errorMsg, setMsg] = useState("");
    const [flippedIsOpen, setFlippedIsOpen] = useState(false);

    var utype = 'w';

    function dynamicStyle()
    {
        if (utype == 'w') return classes.buttonW;
        return classes.buttonE;
    }

    function dynamicStyle2()
    {
        if (utype == 'w') return classes.linkW;
        return classes.linkE;
    }

    function getClassName()
    {
        if (flippedIsOpen) return classes.card_active;
        return classes.card;
    }

    function flip()
    {
        setFlippedIsOpen(true);
    }

    return (
        <div className={classes.back}>
            <div className={getClassName()}>
                <div className={classes.card_inner}>
                    <div className={classes.card_front}>
                        <h2 className={classes.h2}>PASSWORD RESET</h2>
                        <p className={classes.p}>Enter your email below to start the password reset process.</p>
                        <form className={classes.center}>
                            <input type='email' className={classes.input3} required id='email' ref={emailRef}/><br></br>
                            <Link to='/' className={classes.link}>Cancel</Link>
                            <button className={classes.button} onClick={flip}>Continue</button>
                        </form>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                    </div>
                    <div className={classes.card_back}>
                        <h2 className={classes.h2}>PASSWORD RESET</h2>
                        <p className={classes.p}>We've sent you an email with a verification code. Enter it below along with your new password.</p>
                        <form className={classes.center}>
                            <label className={classes.p}>Code</label> <br></br>
                            <input type='text' className={classes.input} required id='verify' ref={verRef}/><br></br>
                            <label className={classes.p}>New Password</label> <br></br>
                            <input type='password' className={classes.input2} required id='pass' ref={passRef}/><br></br>
                            <label className={classes.p}>Confirm Password</label> <br></br>
                            <input type='password' className={classes.input2} required id='confpass' ref={confRef}/><br></br>
                            <Link to='/' className={dynamicStyle2()}>Cancel</Link>
                            <button className={dynamicStyle()}>Confirm</button>
                        </form>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                    </div>
                </div>
            </div>
        </div>
    );
}

export default ForgotPassword;