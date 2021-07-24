import classes from './Verify.module.css';
import {useRef} from 'react';
import {useState} from 'react';
import { withRouter } from 'react-router-dom';

function Verify(props)
{
    const verRef = useRef();
    const [errorMsg, setMsg] = useState("");
    var user = JSON.parse(localStorage.getItem('user_data'));
    function dynamicStyle()
    {
        const utypeF = user.Flag;

        if (utypeF == 0) var utype = 'w';
        else var utype = 'e';

        if (utype == 'w') return classes.buttonW;
        return classes.buttonE;
    }

    async function verifyHandler(event)
    {
        event.preventDefault();
        const ver = verRef.current.value;

        const Data =
        {
            email: user.Email,
            verificationCode: ver
        };

        var js = JSON.stringify(Data);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/verify', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
        }

        if (res.error == '')
        {
            user.Verified = true;
            localStorage.setItem('user_data', JSON.stringify(user));
            props.history.push('/jobs-w');
        }
    }

    return (
        <div className={classes.back}>
            <div className={classes.card}>
                <h2 className={classes.h2}>ALMOST DONE</h2>
                <p className={classes.p}>We've sent you an email with a verification code. Enter it below to complete your registration.</p>
                <form className={classes.center}>
                    <input type='text' className={classes.input} required id='verify' ref={verRef}/><br></br>
                    <button className={dynamicStyle()} onClick={verifyHandler}>Verify</button>
                </form>
                {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
            </div>
        </div>
    );
}

export default withRouter(Verify);