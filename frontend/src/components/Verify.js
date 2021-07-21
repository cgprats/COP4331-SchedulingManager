import classes from './Verify.module.css';
import {useRef} from 'react';
import {useState} from 'react';

function Verify(props)
{
    const verRef = useRef();
    const [errorMsg, setMsg] = useState("");

    function dynamicStyle()
    {
        if (props.utype == 'w') return classes.buttonW;
        return classes.buttonE;
    }

    return (
        <div className={classes.card}>
            <h2 className={classes.h2}>ALMOST DONE</h2>
            <p className={classes.p}>We've sent you an email with a verification code. Enter it below to complete your registration.</p>
            <form className={classes.center}>
                <input type='text' className={classes.input} required id='verify' ref={verRef}/><br></br>
                <button className={dynamicStyle()}>Verify</button>
            </form>
            {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
        </div>
    );
}

export default Verify;