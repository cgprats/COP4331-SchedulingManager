import classes from './Job.module.css';
import {useState} from 'react';
import Backdrop from './Backdrop';
import Notes from './Notes';
import Timesheet from './Timesheet';
import Edit from './Edit';

const DUMMY_DATA = [
    {
        name: 'Sean Bennett',
        date: '7/18/2021',
        desc: 'This is an example of a note. It is relatively short.'
    },
    {
        name: 'Trish Nigrelli',
        date: '7/20/2021',
        desc: 'This is an example of a longer note. As you can see, it takes up more space. In fact, one might even say that it takes up an utterly absurd amount of space, but its ok cuz it wraps.'
    }
];

const DUMMY_DATA2 = [
    {
        name: 'Sean Bennett',
        date: '7/18/2021',
        start: '11:00',
        end: '3:30'
    },
    {
        name: 'Trish Nigrelli',
        date: '7/18/2021',
        start: '11:05',
        end: '3:42'
    },
    {
        name: 'Sean Bennett',
        date: '7/19/2021',
        start: '11:10',
        end: '-----'
    }

];

function Job(props)
{
    const [errorMsg, setMsg] = useState("");
    const [backdropIsVisible, setBackdropVisiblity] = useState(false);
    const [notesAreVisible, setNoteVisibility] = useState(false);
    const [timesheetIsVisible, setTimesheetVisibility] = useState(false);
    const [editIsVisible, setEditVisibility] = useState(false);

    function loadNotes()
    {
        setNoteVisibility(true);
        setBackdropVisiblity(true);
    }

    function loadTimesheet()
    {
        setTimesheetVisibility(true);
        setBackdropVisiblity(true);
    }

    function loadEdit()
    {
        setEditVisibility(true);
        setBackdropVisiblity(true);
    }

    function closeAll()
    {
        setBackdropVisiblity(false);
        setNoteVisibility(false);
        setTimesheetVisibility(false);
        setEditVisibility(false);
    }

    function reformatDate(input)
    {
        const year = input.substring(0, 4);
        const month = input.substring(5, 7);
        const day = input.substring(8, 10);
        return (month + '/' + day + '/' + year);
    }

    return (
        <div>
            <div className={classes.jobcard}>
                <div className={classes.cardheading}>
                    <h3 className={classes.h3}>{props.title}</h3>
                </div>
                <div>
                    <div className={classes.spacer}>
                        <span className={classes.span}>Location: </span>
                        <span className={classes.address}>{props.address}</span>
                    </div>
                    <div>
                        <span className={classes.spanD}>Duration: </span>
                        <span className={classes.date}>{reformatDate(props.start)}</span>
                        <span className={classes.span2}> to </span>
                        <span className={classes.date2}>{reformatDate(props.end)}</span>
                    </div>
                    <div>
                        <span className={classes.spanC}>Client: </span>
                        <span className={classes.client}>{props.client}</span>
                        <span className={classes.email}>{props.email}</span>
                        <span className={classes.phone}>{props.phone}</span>
                    </div>
                    <div className={classes.center}>
                        <span className={classes.details}>Team: {props.workers.length}/{props.maxWorkers}</span><br></br>
                        <ul className={classes.ul}>
                            {props.workers.map(worker => 
                                <li className={classes.worker} key={worker.email}>
                                    <span className={classes.info}>{worker.name}</span>
                                    <span className={classes.info}>{worker.email}</span>
                                    <span className={classes.info}>{worker.phone}</span>
                                </li>
                            )}
                        </ul>
                    </div>
                    <div className={classes.center}>
                        <span className={classes.details}>Details:</span><br></br>
                        <p className={classes.brief}>{props.briefing}</p>
                    </div>
                    <div>
                        {errorMsg && <span className={classes.error}>{errorMsg}</span>}
                    </div>
                </div>
                <div className={classes.cardfooter}>
                    <button className={classes.noteButton} onClick={loadNotes}>Notes</button>
                    <button className={classes.noteButton} onClick={loadTimesheet}>Timesheet</button>
                    {props.utype == 'w' && <button className={classes.signButton}>Sign on/off</button>}
                    {props.utype == 'w' && <button className={classes.signButton}>Clock in/out</button>}
                    {props.utype == 'e' && <button className={classes.signButton}>Delete</button>}
                    {props.utype == 'e' && <button className={classes.signButton} onClick={loadEdit}>Edit</button>}
                    {props.utype == 'e' && <button className={classes.signButton}>Mark Done</button>}
                </div>
            </div>
            {backdropIsVisible && <Backdrop onClick={closeAll}></Backdrop>}
            {notesAreVisible && <Notes input={DUMMY_DATA} onClick={closeAll}></Notes>}
            {timesheetIsVisible && <Timesheet input={DUMMY_DATA2} onClick={closeAll}></Timesheet>}
            {editIsVisible && <Edit 
                title = {props.title}
                address = {props.address}
                client = {props.client}
                email = {props.email}
                phone = {props.phone}
                maxWorkers = {props.maxWorkers}
                start = {props.start}
                end = {props.end}
                briefing = {props.briefing}
                onClick={closeAll}></Edit>}
        </div>
    );
}

export default Job;