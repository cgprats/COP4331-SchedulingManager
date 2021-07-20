import {useRef} from 'react';
import {Link} from 'react-router-dom';
import classes from './SignUpE.module.css';
import employerLogo from '../icons/Employer.png';
import {useState} from 'react';

function SignUpE()
{
    const fnRef = useRef();
    const lnRef = useRef();
    const emailRef = useRef();
    const phoneRef = useRef();
    const nameRef = useRef();
    const passRef = useRef();
    const pass2Ref = useRef();
    const [errorMsg, setMsg] = useState("");

    async function submitHandler(event)
    {
        event.preventDefault();
        const fn = fnRef.current.value;
        const ln = lnRef.current.value;
        const email = emailRef.current.value;
        const phone = phoneRef.current.value;
        const coName = nameRef.current.value;
        const password = passRef.current.value;
        const confpass = pass2Ref.current.value;

        const signupData =
        {
            firstName: fn,
            lastName: ln,
            email: email,
            phone: phone,
            flag: 1,
            companyCode: null,
            companyName: coName,
            password: password,
            password_confirm: confpass
        };

        var js = JSON.stringify(signupData);
        try{
            const response = await fetch('https://cop4331group2.herokuapp.com/api/register', 
            {method: 'POST', body:js, headers:{'Content-Type': 'application/json'}});
            var res = JSON.parse(await response.text());
            setMsg(res.error);

        }catch(e){
            alert(e.toString());
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
                            <label className={classes.label}>Phone (Format 123-456-7890)</label><br></br>
                            <input type='text' className={classes.input} required id='phone' pattern = "[0-9]{3}-[0-9]{3}-[0-9]{4}" ref={phoneRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Company Name</label><br></br>
                            <input type='text' className={classes.input} required id='name' ref={nameRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Password</label><br></br>
                            <input type='password' className={classes.input} required id='password' ref={passRef}/>
                        </div>
                        <div>
                            <label className={classes.label}>Confirm Password</label><br></br>
                            <input type='password' className={classes.input} required id='passwordconf' ref={pass2Ref}/>
                        </div>
                    
                        <div>
                            {errorMsg && (<p className={classes.error}>{errorMsg}</p>)}
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