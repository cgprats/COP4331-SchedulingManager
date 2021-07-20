import classes from './LoginBackside.module.css';
import { withRouter } from 'react-router-dom';
import workerLogo from '../icons/Workers.png';
import employerLogo from '../icons/Employer.png';

function LoginBackside(props)
{
    function loadEmployer()
    {
        props.history.push('/sign-up1');
    }

    function loadWorker()
    {
        props.history.push('/sign-up2');
    }

    return (
        <div>
            <div className='card'>
                <div className={classes.col} onClick={loadEmployer}>
                    <img src={employerLogo} className={classes.image}/>
                    <h3 className={classes.h3}>EMPLOYER</h3>
                 </div>
                 <div className={classes.right} onClick={loadWorker}>
                    <img src={workerLogo} className={classes.image2}/>
                    <h3 className={classes.second}>WORKER</h3>
                 </div>
                
            </div>
            <div>
                <h4 className={classes.h4}>WHAT IS YOUR ROLE?</h4>
                <span className={classes.span}>Already have an account?</span>
                <button className={classes.link} onClick={props.onClick}> Sign in!</button>
            </div>
        </div>
    );
}

export default withRouter(LoginBackside);