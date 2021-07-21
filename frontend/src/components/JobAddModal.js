import classes from './JobAddModal.module.css';
import {useRef} from 'react';

function JobAddModal(props)
{
    const titleRef = useRef();
    const addressRef = useRef();
    const maxRef = useRef();
    const clientNameRef = useRef();
    const clientEmailRef = useRef();
    const clientPhoneRef = useRef();
    const startRef = useRef();
    const endRef = useRef();
    const briefRef = useRef();

    function addHandler()
    {

    }

    return (
        <div className={classes.card}>
            <div className={classes.cardheading}>
                <h3 className={classes.h3}>Add New Job</h3>
                <button className={classes.close} onClick={props.onClick}>X</button>
            </div>
            <div>
                <form onSubmit={addHandler}>
                    <div>
                        <span className={classes.span}>Title</span>
                        <span className={classes.span2}>Address</span>
                        <span className={classes.span3}># Workers</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search} id='title' ref={titleRef}/>
                        <input type='text' className={classes.search} id='address' ref={addressRef}/> 
                        <input type='text' className={classes.work} id='maxWorkers' ref={maxRef}/>
                    </div>
                    <div>
                        <span className={classes.span}>Client Name</span>
                        <span className={classes.span4}>Client Email</span>
                        <span className={classes.span5}>Client Phone</span>
                    </div>
                    <div className={classes.center}>
                        <input type='text' className={classes.search2} id='cName' ref={clientNameRef}/>
                        <input type='email' className={classes.search2} id='cEmail' ref={clientEmailRef}/>
                        <input type='text' className={classes.search2} id='cPhone' pattern='[0-9]{3}-[0-9]{3}-[0-9]{4}' placeholder='Format: 123-456-7890' ref={clientPhoneRef}/>
                    </div>
                    <div>
                        <span className={classes.span6}>Start Date</span>
                        <span className={classes.span7}>End Date</span> <br></br>
                    </div>
                    <div className={classes.center}>
                        <input type='date' className={classes.date} id='start' ref={startRef}/>
                        <input type='date' className={classes.date} id='end' ref={endRef}/> <br></br>
                        <textarea rows='5' cols='75' className={classes.ta} placeholder='Job briefing' ref={briefRef}></textarea> <br></br>
                        <button className={classes.button}>Add Job</button>
                    </div>
                </form>
            </div>
        </div>
    );
}

export default JobAddModal;