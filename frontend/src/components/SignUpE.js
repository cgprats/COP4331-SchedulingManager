import {useRef} from 'react';
import {Link} from 'react-router-dom';
import classes from './SignUpE.module.css';
import employerLogo from '../icons/Employer.png';

function SignUpE()
{
    const fnRef = useRef();
    const lnRef = useRef();
    const emailRef = useRef();
    const phoneRef = useRef();
    const codeRef = useRef();
    const passRef = useRef();

    function submitHandler(event)
    {
        event.preventDefault();

        const fn = fnRef.current.value;
        const ln = lnRef.current.value;
        const email = emailRef.current.value;
        const phone = phoneRef.current.value;
        const code = codeRef.current.value;
        const password = passRef.current.value;

        const signupData =
        {
            FirstName: fn,
            LastName: ln,
            email: email,
            Phone: phone,
            Code: code,
            password: password
        }
    }

    return (
        <div className='card'>
            <div className={classes.col}>
                <img src={employerLogo} className={classes.image}/>
                <h3 className={classes.h3}>EMPLOYER</h3>
            </div>
            <div className={classes.right}>
                <h2 className={classes.h2}>SIGN UP</h2>
                    <form onSubmit={submitHandler}>
                        <div>
                            <label className={classes.label}>First Name</label><br></br>
                            <input type='text' className={classes.input} required id='first' ref={fnRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Last Name</label><br></br>
                            <input type='text' className={classes.input} required id='last' ref={lnRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Email</label><br></br>
                            <input type='email' className={classes.input} required id='email' ref={emailRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Phone</label><br></br>
                            <input type='text' className={classes.input} required id='phone' ref={phoneRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Company Name</label><br></br>
                            <input type='text' className={classes.input} required id='code' ref={codeRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Password</label><br></br>
                            <input type='password' className={classes.input} required id='password' ref={passRef}/>
                        </div>
                    
                        <div>
                            <button className = {classes.myButton}>Sign up</button>
                        </div>
                    </form>
                    <div>
                        <span className={classes.span}>Already have an account? </span>
                        <Link to='/' className = {classes.link}>Sign in!</Link>
                    </div>
                
            </div>
        </div>
    );
}

export default SignUpE;