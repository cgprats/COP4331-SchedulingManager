import classes from './ForgotPassword.module.css';
import {useRef} from 'react';
import {useState} from 'react';
import {Link} from 'react-router-dom';
import {withRouter} from 'react-router-dom';

function ForgotPassword(props)
{
    const verRef = useRef();
    const emailRef = useRef();
    const passRef = useRef();
    const confRef = useRef();


    const [errorMsg, setMsg] = useState("");
    const [flippedIsOpen, setFlippedIsOpen] = useState(false);

    var utype = 'w';
    var email = '';

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

    async function flip(event)
    {
        event.preventDefault();
        email = emailRef.current.value;

        const Data =
        {
            email: email,
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/sendcode', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if (res.error == 'Success')
        {
            setFlippedIsOpen(true);
        }
    }

    async function submitHandler(event)
    {
        event.preventDefault();
        var ver = verRef.currentvalue;
        var password = passRef.current.value;
        var passConf = confRef.current.value;

        const Data =
        {
            email: email,
            ver: ver,
            new_password: password,
            new_password_confirm: passConf
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/changepassword', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if (res.error == 'Password changed, redirecting to login')
        {
            await new Promise(r => setTimeout(r, 3000));
            props.history.push('/');
        }

    }

    return (
        <div className={classes.back}>
            <div className={getClassName()}>
                <div className={classes.card_inner}>
                    <div className={classes.card_front}>
                        <h2 className={classes.h2}>PASSWORD RESET</h2>
                        <p className={classes.p}>Enter your email below to start the password reset process.</p>
                        <form className={classes.center} onSubmit={flip}>
                            <input type='email' className={classes.input3} required id='email' ref={emailRef}/><br></br>
                            {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                            <Link to='/' className={classes.link}>Cancel</Link>
                            <button className={classes.button}>Continue</button>
                        </form>
                        {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
                    </div>
                    <div className={classes.card_back}>
                        <h2 className={classes.h2}>PASSWORD RESET</h2>
                        <p className={classes.p}>We've sent you an email with a verification code. Enter it below along with your new password.</p>
                        <form className={classes.center} onSubmit={submitHandler}>
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

export default withRouter(ForgotPassword);