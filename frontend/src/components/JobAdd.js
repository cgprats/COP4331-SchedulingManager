import JobAddModal from './JobAddModal';
import Backdrop from './Backdrop';
import classes from './JobAdd.module.css';
import {useState} from 'react';

function JobAdd()
{
    const [backdropIsVisible, setBackdropVisiblity] = useState(false);
    const [modalIsVisible, setModalVisibility] = useState(false);

    function closeAll()
    {
        setBackdropVisiblity(false);
        setModalVisibility(false);
    }

    function openModal()
    {
        setBackdropVisiblity(true);
        setModalVisibility(true);
    }

    return (
        <div>
            <div className={classes.panel}>
                <span className={classes.span}>Add New Job</span>
                <button className={classes.add} onClick={openModal}>+</button>
            </div>
            {backdropIsVisible && <Backdrop onClick={closeAll}></Backdrop>}
            {modalIsVisible && <JobAddModal onClick={closeAll}></JobAddModal>}
        </div>
    );
}

export default JobAdd;